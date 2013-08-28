require 'spec_helper'

describe "StaticPages" do

  subject { page } 
  let(:user) { FactoryGirl.create(:user) }

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "Chapter 03"
    expect(page).to have_title(full_title(''))
  end

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Chapter 03' }
    let(:page_title) { '' } 

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      
      describe "micropost pagination" do
        before do 
          31.times { FactoryGirl.create(:micropost, user: user) } 
          visit root_path
        end
        after(:all) { user.microposts.delete_all }

        it { should have_selector('div.pagination') }

        it "should list each micropost" do
          user.microposts.paginate(page: 1).each do |micropost|
            expect(page).to have_selector('li', text: micropost.content)
          end
        end
      end

      describe "should have pluralized micropost total" do
        it { should have_selector('.total_microposts', text: "2 microposts") }
        it "should have a singular micropost" do
          user.microposts.first.destroy
          visit root_path
          expect(page).to have_selector(".total_microposts", text: "1 micropost")
        end
        it "should have zero microposts" do
          user.microposts.first.destroy
          user.microposts.first.destroy
          visit root_path
          expect(page).to have_selector(".total_microposts", text: "0 microposts")
        end
      end

    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' } 

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About' } 

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' } 

    it_should_behave_like "all static pages"
  end

end
