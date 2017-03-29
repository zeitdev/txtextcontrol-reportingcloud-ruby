require 'spec_helper'
require "txtextcontrol/reportingcloud/merge_block"

describe TXTextControl::ReportingCloud::MergeBlock do
  let (:hash) {
    {
      "name" => "Sales_SalesOrderDetail",
      "mergeFields" => [
        {
          "dateTimeFormat" => "",
          "name" => "Production_Product.ProductNumber",
          "numericFormat" => "",
          "preserveFormatting" => false,
          "text" => "«ProductNumber»",
          "textAfter" => "",
          "textBefore" => ""
        },
        {
          "dateTimeFormat" => "",
          "name" => "Production_Product.Name",
          "numericFormat" => "",
          "preserveFormatting" => false,
          "text" => "«Name»",
          "textAfter" => "",
          "textBefore" => ""
        },
        {
          "dateTimeFormat" => "",
          "name" => "OrderQty",
          "numericFormat" => "",
          "preserveFormatting" => false,
          "text" => "«OrderQty»",
          "textAfter" => "",
          "textBefore" => ""
        },
        {
          "dateTimeFormat" => "",
          "name" => "UnitPrice",
          "numericFormat" => "$#,###.00",
          "preserveFormatting" => false,
          "text" => "«UnitPrice»",
          "textAfter" => "",
          "textBefore" => ""
        },
        {
          "dateTimeFormat" => "",
          "name" => "LineTotal",
          "numericFormat" => "$#,###.00",
          "preserveFormatting" => false,
          "text" => "«LineTotal»",
          "textAfter" => "",
          "textBefore" => ""
        }
      ],
      "mergeBlocks" => [
        {
          "name" => "Nested_Block",
          "mergeFields" => [
            {
              "dateTimeFormat" => "",
              "name" => "Production_Product.ProductNumber",
              "numericFormat" => "",
              "preserveFormatting" => false,
              "text" => "«ProductNumber»",
              "textAfter" => "",
              "textBefore" => ""
            },
            {
              "dateTimeFormat" => "",
              "name" => "Production_Product.Name",
              "numericFormat" => "",
              "preserveFormatting" => false,
              "text" => "«Name»",
              "textAfter" => "",
              "textBefore" => ""
            },
            {
              "dateTimeFormat" => "",
              "name" => "OrderQty",
              "numericFormat" => "",
              "preserveFormatting" => false,
              "text" => "«OrderQty»",
              "textAfter" => "",
              "textBefore" => ""
            },
          ],
          "mergeBlocks" => []
        }        
      ]
    }
  }

  describe ".from_camelized_hash" do
    it "creates an instance from a hash using camel case attributes" do
      block = TXTextControl::ReportingCloud::MergeBlock::from_camelized_hash(hash)
      expect(block.name).to eq("Sales_SalesOrderDetail")
      expect(block.merge_blocks.length).to eq(1)
      expect(block.merge_blocks[0].name).to eq("Nested_Block")
      expect(block.merge_blocks[0].merge_blocks.length).to eq(0)
      expect(block.merge_fields.length).to eq(5)
      expect(block.merge_fields[2].name).to eq("OrderQty")
    end
  end
end
