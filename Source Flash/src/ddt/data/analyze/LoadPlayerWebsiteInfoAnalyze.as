package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   
   public class LoadPlayerWebsiteInfoAnalyze extends DataAnalyzer
   {
       
      
      public var info:Dictionary;
      
      public function LoadPlayerWebsiteInfoAnalyze(param1:Function)
      {
         this.info = new Dictionary(true);
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = new XML(param1);
         if(_loc2_)
         {
            this.info["uid"] = _loc2_.uid.toString();
            this.info["name"] = _loc2_.name.toString();
            this.info["gender"] = _loc2_.gender.toString();
            this.info["userName"] = _loc2_.userName.toString();
            this.info["university"] = _loc2_.university.toString();
            this.info["city"] = _loc2_.city.toString();
            this.info["tinyHeadUrl"] = _loc2_.tinyHeadUrl.toString();
            this.info["largeHeadUrl"] = _loc2_.largeHeadUrl.toString();
            this.info["personWeb"] = _loc2_.personWeb.toString();
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
