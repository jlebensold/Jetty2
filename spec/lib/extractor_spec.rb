require 'extractor'
describe Extractor do 
  it 'should get content' do
    e = Extractor.new("<html><body><div><p>sometext</p></div></body></html>") 
    e.content.should == "sometext"
  end

  it 'should get content from nested div' do
    e = Extractor.new("<html><body><div><p>sometext</p></div></body></html>") 
    e.content.should == "sometext"
  end

  it 'should get content from bigest divs with the most p tags' do
    e = Extractor.new(%{
    <html>
      <body>
        <div>
          <div>
            <p>sometext</p>
          </div>
          <div>
            <p>this is a</p>
            <p> much bigger div</p>
          </div>
        </div>
      </body>
    </html>
    }) 
    e.content.should == "this is a\n much bigger div"
  end

end
