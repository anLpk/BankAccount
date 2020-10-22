require 'date'

class DepositError < StandardError
end

class BankAccount
  MIN_DEPOSIT = 100
  attr_reader :name, :balance

  def initialize(name, iban, initial_deposit, password)
    fail DepositError, "Insufficient deposit" unless initial_deposit > MIN_DEPOSIT

    @password     = password
    @transactions = []
    @balance      = 0
    @name         = name
    @iban         = iban
    add_transaction(initial_deposit)
  end

  def withdraw(amount)
    add_transaction(-amount)
    "your withdrawal amount = #{amount}"
  end

  def deposit(amount)
    add_transaction(+amount)
    "your withdrawal amount = #{amount}"
  end

  def transactions_history(args = {})
    # Should return a string displaying the transactions, BUT NOT return the transaction array !
    password = args[:password]
    if password.nil?
      "no password given"
    elsif password != @password
      "wrong password"
    else
      @transactions.join(',')
    end
  end

  def iban
    @iban.gsub(/([-() ])/, '').sub(/(?<=\A.{4})(.*)(?=.{3}\z)/) { |match| '*' * match.length }
  end

  def to_s
    "#{@name} - #{iban} - Balance: #{@balance} "
  end

  private

  def add_transaction(amount)
    @balance += amount
    @transactions << "Date.today - Time.now - Deposited#{amount} - Balance is #{@balance}"
  end
end
