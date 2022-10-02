package tofflist.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import tofflist.data.RankInfo;
   
   public class RankInfoAnalyz extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      public var info:RankInfo;
      
      public function RankInfoAnalyz(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         this._xml = new XML(param1);
         if(this._xml.@value == "true")
         {
            _loc2_ = XML(this._xml)..Item;
            this.info = new RankInfo();
            ObjectUtils.copyPorpertiesByXML(this.info,_loc2_[0]);
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
