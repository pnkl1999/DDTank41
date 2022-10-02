package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   
   public class WeaponBallInfoAnalyze extends DataAnalyzer
   {
       
      
      public var bombs:Dictionary;
      
      public function WeaponBallInfoAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var attr:XMLList = null;
         var bombIds:Array = null;
         var TemplateID:int = 0;
         var item:XML = null;
         var propname:String = null;
         var value:int = 0;
         var data:* = param1;
         var xml:XML = new XML(data);
         this.bombs = new Dictionary();
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            i = 0;
            while(i < xmllist.length())
            {
               attr = xmllist[i].attributes();
               bombIds = [];
               for each(item in attr)
               {
                  propname = item.name().toString();
                  try
                  {
                     if(propname == "TemplateID")
                     {
                        TemplateID = int(item);
                     }
                     else
                     {
                        value = int(item);
                        bombIds.push(value);
                     }
                  }
                  catch(e:Error)
                  {
                     continue;
                  }
               }
               this.bombs[TemplateID] = bombIds;
               i++;
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
