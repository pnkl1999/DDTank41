package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.GradeBoxInfo;
   import ddt.data.box.TimeBoxInfo;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class UserBoxInfoAnalyzer extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      private var _goodsList:XMLList;
      
      public var timeBoxList:DictionaryData;
      
      public var gradeBoxList:DictionaryData;
      
      public var boxTemplateID:Dictionary;
      
      public function UserBoxInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         this._xml = new XML(param1);
         this._xml = this.getXML();
         if(this._xml.@value == "true")
         {
            this.timeBoxList = new DictionaryData();
            this.gradeBoxList = new DictionaryData();
            this.boxTemplateID = new Dictionary();
            this._goodsList = this._xml..Item;
            this.parseShop();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function parseShop() : void
      {
         var _loc2_:int = 0;
         var _loc3_:TimeBoxInfo = null;
         var _loc4_:GradeBoxInfo = null;
         var _loc5_:TimeBoxInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._goodsList.length())
         {
            _loc2_ = this._goodsList[_loc1_].@Type;
            switch(_loc2_)
            {
               case 0:
                  _loc3_ = new TimeBoxInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc3_,this._goodsList[_loc1_]);
                  this.boxTemplateID[_loc3_.TemplateID] = _loc3_.TemplateID;
                  this.timeBoxList.add(_loc3_.ID,_loc3_);
                  break;
               case 1:
                  _loc4_ = new GradeBoxInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,this._goodsList[_loc1_]);
                  this.boxTemplateID[_loc4_.TemplateID] = _loc4_.TemplateID;
                  this.gradeBoxList.add(_loc4_.ID,_loc4_);
                  break;
               case 2:
                  _loc5_ = new TimeBoxInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc5_,this._goodsList[_loc1_]);
                  this.boxTemplateID[_loc5_.TemplateID] = _loc5_.TemplateID;
            }
            _loc1_++;
         }
         onAnalyzeComplete();
      }
      
      private function getXML() : XML
      {
         var _loc1_:XML = <Result value="true" message="Success!">
  <Item ID="1" Type="0" Level="20" Condition="15" TemplateID="1120090"/>
  <Item ID="2" Type="0" Level="20" Condition="40" TemplateID="1120091"/>
  <Item ID="3" Type="0" Level="20" Condition="60" TemplateID="1120092"/>
  <Item ID="4" Type="0" Level="20" Condition="75" TemplateID="1120093"/>
  <Item ID="6" Type="1" Level="4" Condition="1" TemplateID="1120071"/>
  <Item ID="7" Type="1" Level="5" Condition="1" TemplateID="1120072"/>
  <Item ID="8" Type="1" Level="8" Condition="1" TemplateID="1120073"/>
  <Item ID="9" Type="1" Level="10" Condition="1" TemplateID="1120074"/>
  <Item ID="10" Type="1" Level="11" Condition="1" TemplateID="1120075"/>
  <Item ID="11" Type="1" Level="12" Condition="1" TemplateID="1120076"/>
  <Item ID="12" Type="1" Level="15" Condition="1" TemplateID="1120077"/>
  <Item ID="13" Type="1" Level="20" Condition="1" TemplateID="1120078"/>
  <Item ID="14" Type="1" Level="4" Condition="0" TemplateID="1120081"/>
  <Item ID="15" Type="1" Level="5" Condition="0" TemplateID="1120082"/>
  <Item ID="16" Type="1" Level="8" Condition="0" TemplateID="1120083"/>
  <Item ID="17" Type="1" Level="10" Condition="0" TemplateID="1120084"/>
  <Item ID="18" Type="1" Level="11" Condition="0" TemplateID="1120085"/>
  <Item ID="19" Type="1" Level="12" Condition="0" TemplateID="1120086"/>
  <Item ID="20" Type="1" Level="15" Condition="0" TemplateID="1120087"/>
  <Item ID="21" Type="1" Level="20" Condition="0" TemplateID="1120088"/>
  <Item ID="14" Type="2" Level="4" Condition="0" TemplateID="112112"/>
  <Item ID="15" Type="2" Level="5" Condition="0" TemplateID="112113"/>
  <Item ID="16" Type="2" Level="8" Condition="0" TemplateID="112114"/>
  <Item ID="17" Type="2" Level="10" Condition="0" TemplateID="112115"/>
  <Item ID="18" Type="2" Level="11" Condition="0" TemplateID="112116"/>
  <Item ID="19" Type="2" Level="12" Condition="0" TemplateID="112117"/>
  <Item ID="20" Type="2" Level="15" Condition="0" TemplateID="112118"/>
 <Item ID="21" Type="2" Level="20" Condition="0" TemplateID="112119"/>
 <Item ID="21" Type="2" Level="20" Condition="0" TemplateID="112120"/>
</Result>;
         return _loc1_;
      }
   }
}
