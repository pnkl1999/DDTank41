package times.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class TimesAnalyzer extends DataAnalyzer
   {
       
      
      public var webPath:String;
      
      public var edition:int;
      
      public var editor:String;
      
      public var nextDate:String;
      
      public var smallPicInfos:Vector.<TimesPicInfo>;
      
      public var bigPicInfos:Vector.<TimesPicInfo>;
      
      public var contentInfos:Array;
      
      public function TimesAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var k:int = 0;
         var info:TimesPicInfo = null;
         var info1:TimesPicInfo = null;
         var info2:TimesPicInfo = null;
         var data:* = param1;
         this.smallPicInfos = new Vector.<TimesPicInfo>();
         this.bigPicInfos = new Vector.<TimesPicInfo>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            this.webPath = xml.@webPath;
            this.edition = xml.@edition;
            this.editor = xml.@editor;
            this.nextDate = xml.@nextDate;
            xmllist = xml..item.(@type == "small");
            i = 0;
            while(i < xmllist.length())
            {
               info = new TimesPicInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.smallPicInfos.push(info);
               i++;
            }
            xmllist = xml..item.(@type == "big");
            i = 0;
            while(i < xmllist.length())
            {
               info1 = new TimesPicInfo();
               ObjectUtils.copyPorpertiesByXML(info1,xmllist[i]);
               this.bigPicInfos.push(info1);
               i++;
            }
            this.contentInfos = new Array();
            k = 0;
            while(k < 4)
            {
               xmllist = xml..item.(@type == "category" + String(k));
               this.contentInfos.push(new Vector.<TimesPicInfo>());
               i = 0;
               while(i < xmllist.length())
               {
                  info2 = new TimesPicInfo();
                  ObjectUtils.copyPorpertiesByXML(info2,xmllist[i]);
                  info2.category = k;
                  info2.page = i;
                  this.contentInfos[k].push(info2);
                  i++;
               }
               k++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
