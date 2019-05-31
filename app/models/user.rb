class User < ApplicationRecord

  before_save { self.email = email.downcase } #DBに保存する前にemail属性を強制的に小文字に変換する

  validates :name, presence: true, length: { maximum: 50 } #nameは空は許さず、50文字以下

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i #emailに使用される正規表現

  validates :email, presence: true, length: { maximum: 255 }, #emailは空を許さず255文字以下
              format: { with: VALID_EMAIL_REGEX }, #VALID_EMAIL_REGEXに一致するemailだけ有効であることをチェックできるようになる
              uniqueness: { case_sensitive: false } #「uniqueness」は対象のDB内で一意である必要であるフィールドに対して指定。「case_sensigtive」は「false」を指定することで、大文字小文字の差を無視する。

  has_secure_password #セキュアなパスワードの実行
  validates :password, presence: true, length: { minimum: 6 }

  # fixture用に、password_digestの文字列をハッシュ化して、ハッシュ値として返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                   BCrypt::Engine.cost
     BCrypt::Password.create(string, cost: cost)
   end

end
