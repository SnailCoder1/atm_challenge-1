require 'date'
require './lib/account'
require './lib/person'

class Atm 
    attr_accessor :funds, :bill_divider

    def initialize 
        @funds = 1000
        @bill_divider = 5
    end
    
    def withdraw(amount, pin_code, account)
        case
        when account_is_disabled?(account.account_status)
            { status: false, message: 'account is disabled', date: Date.today }
        when insufficient_funds_in_account?(amount, account)
            {status: false, message: 'insufficient funds in account', date: Date.today }
        when insufficient_funds_in_atm?(amount)    
            { status: false, message: 'insufficient funds in ATM', date: Date.today }
        when incorrect_pin?(pin_code, account.pin_code)
            {status: false, message: 'wrong pin', date: Date.today }
        when card_expired?(account.exp_date)
            { status: false, message: 'card expired', date: Date.today }
        when amount_correct?(amount)
            {status: false, message: "Amount need to be divisible by #{@bill_divider}", date: Date.today }
        else
            perform_transaction(amount, account)
        end
    end

    private

    def amount_correct?(amount)
        amount % @bill_divider != 0
    end
    
    def insufficient_funds_in_account?(amount, account)
    amount > account.balance
    end

    def insufficient_funds_in_atm?(amount)
        @funds < amount
    end
    
    def incorrect_pin?(pin_code, actual_pin)
        pin_code != actual_pin
    end

    def card_expired?(exp_date)
        Date.strptime(exp_date, '%m/%y') < Date.today 
    end

    def account_is_disabled?(account_status)
        account_status == :disabled
    end
    
    def perform_transaction(amount, account)
        @funds -= amount
        account.balance = account.balance - amount
        { status: true, message: 'success', date: Date.today, amount: amount, bills: add_bills(amount) }
    end

    def add_bills(amount)
        bill_options = [20, 10, 5]
        bills = []
        bill_options.each do |bill|
        while amount - bill >= 0
            amount -= bill
            bills << bill
        end
    end
    bills
end
end