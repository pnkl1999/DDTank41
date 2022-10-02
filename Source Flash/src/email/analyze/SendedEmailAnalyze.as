package email.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import email.data.EmailInfoOfSended;
   import flash.utils.describeType;
   
   public class SendedEmailAnalyze extends DataAnalyzer
   {
       
      
      private var _list:Array;
      
      public function SendedEmailAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var ecInfo:XML = null;
         var i:int = 0;
         var info:EmailInfoOfSended = null;
         this._list = new Array();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml.Item;
            ecInfo = describeType(new EmailInfoOfSended());
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new EmailInfoOfSended();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.list.push(info);
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
      
      public function get list() : Array
      {
         return this._list;
      }
   }
}
