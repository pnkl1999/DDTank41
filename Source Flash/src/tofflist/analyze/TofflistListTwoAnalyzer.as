package tofflist.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.describeType;
   import tofflist.data.TofflistListData;
   import tofflist.data.TofflistPlayerInfo;
   
   public class TofflistListTwoAnalyzer extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      public var data:TofflistListData;
      
      public function TofflistListTwoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:TofflistPlayerInfo = null;
         var _loc5_:XML = null;
         var _loc6_:int = 0;
         var _loc7_:TofflistPlayerInfo = null;
         this._xml = new XML(param1);
         var _loc2_:Array = new Array();
         this.data = new TofflistListData();
         this.data.lastUpdateTime = this._xml.@date;
         if(this._xml.@value == "true")
         {
            _loc3_ = XML(this._xml)..Item;
            _loc4_ = new TofflistPlayerInfo();
            _loc5_ = describeType(_loc4_);
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length())
            {
               _loc7_ = new TofflistPlayerInfo();
               _loc7_.beginChanges();
               ObjectUtils.copyPorpertiesByXML(_loc7_,_loc3_[_loc6_]);
               _loc7_.commitChanges();
               _loc2_.push(_loc7_);
               _loc6_++;
            }
            this.data.list = _loc2_;
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
