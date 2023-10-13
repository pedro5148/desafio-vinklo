class User < ApplicationRecord
  # Usando regex para validar o formato do email.
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "invalido, verifique!" }

  # Validadndo o cpf com a gem cpf_validator
  validates :cpf, cpf: { message: "invalido, verifique os valores digitados." }
    
  # Validando o telefone com regex
  PHONE_REGEX = /\A\(\d{2}\) \d \d{4}-\d{4}\z/

  # Valida o formato do telefone
  validates :phone, format: { with: PHONE_REGEX, message: "Verifiquei o telefone digitado." }

  # Callback para formatar o telefone antes de salvar
  before_validation :format_phone

  private

  def format_phone
    return if phone.nil?

    # Remove todos os caracteres não numéricos do telefone
    phone.gsub!(/\D/, '')

    # Formata o telefone para (xx) x xxxx-xxxx
    if phone.length == 11
      self.phone = "(#{phone[0..1]}) #{phone[2]} #{phone[3..6]}-#{phone[7..10]}"
    end
  end

  # Pesquisa por nome, email, telefone ou cpf
  def self.search(query)
    where("name LIKE ? OR email LIKE ? OR phone LIKE ? OR cpf LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
  end
end
