require 'spec_helper'

describe 'User' do

	before { @user = User.new(name: "Example User", email: "user@example.com",
							password: "foobar", password_confirmation: "foobar") }

	subject { @user }

	it { expect(respond_to(:name)).to be_truthy }
	it { expect(respond_to(:email)).to be_truthy }
	it { expect(respond_to(:password_digest)).to be_truthy }
	it { expect(respond_to(:password)).to be_truthy }
	it { expect(respond_to(:password_confirmation)).to be_truthy }
	it { expect(respond_to(:authenticate)).to be_truthy }

	it { expect(@user.valid?) }

	describe "when name is not present" do
		before { @user.name = " " }
		it { expect(@user.valid?).to be_falsey }
	end

	describe "when name is in 50 chars" do
		before { @user.name = 'a' * 50 }
		it { expect(@user.valid?).to be_truthy }
	end

	describe "when name is over 50 chars" do
		before { @user.name = 'a' * 51 }
		it 'should	be invalid' do
			@user.valid?
			expect(@user.errors[:name]).to include('is too long (maximum is 50 characters)')
		end
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { expect(@user.valid?).to be_falsey }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
										 foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user.valid?).to be_falsey
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user.valid?).to be_truthy
			end
		end
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.save
		end

		it { expect(@user.valid?).to be_falsey }
	end

	describe "when password is not present" do
		before do
			@user = User.new(name: "Example User", email: "user@example.com",
							password: " ", password_confirmation: " ")
		end
		it { expect(@user.valid?).to be_falsey }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by(email: @user.email) }

		describe "with valid password" do
			it { expect(@user).to eq (found_user.authenticate(@user.password)) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { expect(@user).not_to eq (:user_for_invalid_password) }
			specify { expect(user_for_invalid_password).to be_falsey }
		end
	end

	describe "with a password that's just size" do
		before { @user.password = @user.password_confirmation = 'a' * 6 }
		it { expect(@user.valid?).to be_truthy }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { expect(@user.valid?).to be_falsey }
	end
end
