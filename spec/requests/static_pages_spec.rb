require 'spec_helper'

describe 'Static pages' do
	subject { page }

	shared_examples_for 'all static pages' do
    it { expect(page).to have_content(heading) }
    it { expect(page).to have_title(full_title(page_title)) }
  end

  describe 'Home page' do
		before { visit '/' }
		let(:heading) {'Sample App'}
		let(:page_title) {''}
		it_behaves_like 'all static pages'
    it { expect(page).not_to have_title('| Home') }
  end

  describe 'Help page' do
		before { visit '/help' }
		let(:heading) {'Help'}
		let(:page_title) {'Help'}
		it_behaves_like 'all static pages'
  end

  describe 'About page' do
		before { visit '/about' }
		let(:heading) {'About Us'}
		let(:page_title) {'About Us'}
		it_behaves_like 'all static pages'
  end

  describe 'Contact page' do
		before { visit '/contact' }
		let(:heading) {'Contact'}
		let(:page_title) {'Contact'}
		it_behaves_like 'all static pages'
  end

	it 'should have the right links on the layout' do
		visit '/'
		click_link 'About'
		expect(page).to have_title(full_title('About Us'))
		click_link 'Help'
		expect(page).to have_title(full_title('Help'))
		click_link 'Contact'
		expect(page).to have_title(full_title('Contact'))
		click_link 'Home'
		click_link 'Sign up now!'
		expect(page).to have_title(full_title('Sign up'))
		click_link 'sample app'
		expect(page).to have_title(full_title(''))
	end
end
