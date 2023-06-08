import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="images"
export default class extends Controller {
  /* ①静的プロパティを定義（data-{controller}-target で指定したターゲット名） */
  static targets = ["select", "preview", "image_box", "error"]

  /********************** 追加↓ *************************/
  imageSizeOver(file){ // アップロードする画像ファイルサイズの上限（2MB）を超えたかどうか判定
    const fileSize = (file.size)/1000 // ファイルサイズ(KB)
    if(fileSize > 2000){
      return true // ファイルサイズが2MBを超えた場合はtrueを返す
    }else{
      return false
    }
  }
  /*******************************************************/

  /* 画像選択時の処理（以下のように編集↓） */
  selectImages(){
    this.errorTarget.textContent = ""
    const uploadedFilesCount = this.previewTarget.querySelectorAll(".image-box").length // すでにアップロードされた画像の枚数
    const files = this.selectTargets[0].files // 選択した画像の枚数（これからアップロードする画像）
    if(files.length + uploadedFilesCount > 1){
      this.errorTarget.textContent = "画像アップロード上限は最大1枚です。"
    }else{
      for(const file of files){
        if(this.imageSizeOver(file)){
          this.errorTarget.textContent = "ファイルサイズの上限(1枚あたり2MB)を超えている画像はアップロードできません。"
        }else{
          this.uploadImage(file) // ファイルのアップロード
        }
      }
    }
    this.selectTarget.value = "" // 選択ファイルのリセット
  }

  /* ②画像選択時の処理 */
  //selectImages(){
  //  const files = this.selectTargets[0].files // file_fieldで取得した画像ファイル
  //  for(const file of files){
  //    this.uploadImage(file) // 選択した画像ファイルのアップロード
  //  }
  //  this.selectTarget.value = "" // 選択ファイルのリセット
  //}

  /* ③画像アップロード */
  uploadImage(file){
    const csrfToken = document.getElementsByName('csrf-token')[0].content // CSRFトークンを取得
    const formData = new FormData()
    formData.append("image", file) // formDataオブジェクトに画像ファイルをセット
    const options = {
      method: 'POST',
      headers: {
        'X-CSRF-Token': csrfToken
      },
      body: formData
    }
 /* fetchで画像ファイルをPostコントローラー(upload_imageアクション)に送信 */
    fetch("/posts/upload_image", options)
      .then(response => response.json())
      .then(data => { // Postコントローラーからのレスポンス(blobデータ)
        this.previewImage(file, data.id) // 画像プレビューアクションにblobデータのidを受け渡す
      })
      .catch((error) => {
        console.error(error)
      })
  }

  /* ④画像プレビュー */
  previewImage(file, id){
    const preview = this.previewTarget // プレビュー表示用の<div>要素
    const fileReader = new FileReader()
    const setAttr = (element, obj)=>{ // 属性設定用の関数
      Object.keys(obj).forEach((key)=>{
        element.setAttribute(key, obj[key])
      })
    }
    fileReader.readAsDataURL(file) // ファイルをData URIとして読み込む
    fileReader.onload = (function () { // ファイル読み込み時の処理
      const img = new Image()
      const imgBox = document.createElement("div")
      const imgInnerBox = document.createElement("div")
      const deleteBtn = document.createElement("a")
      const hiddenField = document.createElement("input")
      const imgBoxAttr = { // imgBoxに設定する属性
        "class" : "image-box inline-flex mx-1 mb-5",
        "data-controller" : "images",
        "data-images-target" : "image_box",
      }
      const imgInnerBoxAttr = { // imgInnerBoxに設定する属性
        "class" : "text-center"
      }
      const deleteBtnAttr = { // deleteBtnに設定する属性
        "class" : "link cursor-pointer",
        "data-action" : "click->images#deleteImage"
      }
      const hiddenFieldAttr = { // hiddenFieldに設定する属性
        "name" : "post[images][]",
        "style" : "none",
        "type" : "hidden",
        "value" : id, // 受け取ったidをセット
      }
      setAttr(imgBox, imgBoxAttr)
      setAttr(imgInnerBox, imgInnerBoxAttr)
      setAttr(deleteBtn, deleteBtnAttr)
      setAttr(hiddenField, hiddenFieldAttr)

      deleteBtn.textContent = "削除"

      imgBox.appendChild(imgInnerBox)
      imgInnerBox.appendChild(img)
      imgInnerBox.appendChild(deleteBtn)
      imgInnerBox.appendChild(hiddenField)
      img.src = this.result
      img.width = 100;

      preview.appendChild(imgBox) // プレビュー表示用の<div>要素の中にimgBox（プレビュー画像の要素）を入れる
    })
  }

  /* ⑤プレビュー画像の削除 */
  deleteImage(){
    this.image_boxTarget.remove()
  }

}
