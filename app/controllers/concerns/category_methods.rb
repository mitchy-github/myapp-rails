module CategoryMethods
  extend ActiveSupport::Concern

  def extract_category(contents_question)
    if contents_question.blank? #例外処理のため。引数が空で渡ってきた場合は処理をしない
      return
    end
    # 入力された文字列の中より、＃で始まる文字列を配列にして返す
      return contents_question.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) #=> ["#aaa","#bbb"]
  end

  #--------------ハッシュタグ保存処理　create update アクションの中で実行----------------
  def save_category(category_array,question_instance)
    if category_array.blank? #ハッシュタグを付けずに投稿された時、下のメソッドを実行させないようにする。
      return
    end
      category_array.uniq.map do |category|
      # ハッシュタグは先頭の#を外し、小文字にして保存
      cate = Category.find_or_create_by(category: category.downcase.delete('#'))

        #-------中間テーブルへの保存処理--------
      category_question = CategoryQuestion.new #中間テーブルのインスタンスを作成
      category_question.question_id = question_instance.id
      category_question.category_id = cate.id
      category_question.save!
    end
  end

  #---------ハッシュタグの情報をPostオブジェクトに含めるメソッド------------
  def creating_structures(questions: "",category_questions: "",categories: "")
    #引数として必要なのはPostのデータ、中間テーブルの全データ、ハッシュタグの全てのデータです。
    #このメソッドはPostのActiveRecordインスタンスをハッシュに変換し、更に一つ一つのオブジェクトに対し、idに紐づくハッシュタグを配列として格納するメソッドです。
    array = [] #最終戻り値用
    questions.each do |question|
      category = [] #中間テーブルのID情報から探したハッシュタグを格納するための配列
        question_cate = question.attributes #ActiveRecordインスタンスをハッシュに変換 { key => val, key=> val}
        related_category_records = category_questions.select{|cq| cq.question_id == question.id } #中間テーブルより投稿idが一致するレコードを取り出す
        related_category_records.each do |record|
          category << categories.detect{ |category| category.id == record.category_id } #上記レコードをもとにハッシュタグを検索し、配列に格納
        end
        question_cate["categories"] = category #投稿一つ一つのデータに['hashtags']のkeyを追加、そこにハッシュタグのデータを格納する
        array << question_cate #=> [{"id"=>1, "title"=>"aaaa", "caption"=>"#aaaa", "created_at"=>Sun, 02 May 2021 15:13:42 UTC +00:00, "updated_at"=>Sun, 02 May 2021 15:13:42 UTC +00:00, "user_id"=>1, "image_id"=>"e347a197a5c2e6466db2d5b1673792c0a7b3a37460b1dea00f36b8b366a6", "hashtag"=>[#<Hashtag id: 1, name: "aaaa", created_at: "2021-05-02 15:13:42", updated_at: "2021-05-02 15:13:42">}]
    end
      return array
  end

  #---------ハッシュタグの情報をハッシュタグテーブルと中間テーブルから削除するメソッド------------
  def delete_records_related_to_category(question_id)
    relationship_records = CategoryQuestion.where(question_id: question_id) #中間テーブルのレコード
    if relationship_records.present? #中間テーブルにレコードが保存されていれば
      relationship_records.each do |record|
          record.destroy #中間テーブルのレコードを削除する
      end
    end
      all_categories = Category.all
      all_related_records = CategoryQuestion.all
      all_categories.each do |category|
        #ハッシュタグに紐づくレコードが中間テーブルに保存されていなければ、ハッシュタグを削除する
        if all_related_records.none?{ |record| category.id == record.category_id }
          category.destroy
        end
      end
  end
end
