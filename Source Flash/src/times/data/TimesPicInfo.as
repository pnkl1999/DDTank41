package times.data
{
   public class TimesPicInfo
   {
      
      public static const SMALL:String = "small";
      
      public static const BIG:String = "big";
      
      public static const CONTENT:String = "content";
       
      
      public var editor:String;
      
      public var path:String;
      
      public var thumbnailPath:String = "thumbnail.png";
      
      public var category:int;
      
      public var page:int;
      
      public var targetCategory:int;
      
      public var targetPage:int;
      
      public var url:String;
      
      public var eventType:String;
      
      public var type:String;
      
      public var templateID:int;
      
      public function TimesPicInfo()
      {
         super();
      }
      
      public function get fileType() : String
      {
         if(this.path)
         {
            return this.path.substr(this.path.lastIndexOf("."));
         }
         return "";
      }
   }
}
