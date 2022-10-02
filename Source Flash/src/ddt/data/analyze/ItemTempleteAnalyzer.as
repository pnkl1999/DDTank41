package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class ItemTempleteAnalyzer extends DataAnalyzer
   {
       
      
      public var list:DictionaryData;
      
      private var _xml:XML;
      
      private var _timer:Timer;
      
      private var _xmllist:XMLList;
      
      private var _index:int;
      
      public function ItemTempleteAnalyzer(param1:Function)
      {
         this.list = new DictionaryData();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         this._xml = new XML(param1);
         this.list = new DictionaryData();
         this.parseTemplate();
      }
      
      protected function parseTemplate() : void
      {
         if(this._xml.@value == "true")
         {
            this._xmllist = this._xml.ItemTemplate..Item;
            this._index = -1;
            this._timer = new Timer(30);
            this._timer.addEventListener(TimerEvent.TIMER,this.__partexceute);
            this._timer.start();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
      
      private function __partexceute(param1:TimerEvent) : void
      {
         var _loc3_:ItemTemplateInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < 40)
         {
            this._index++;
            if(this._index < this._xmllist.length())
            {
               _loc3_ = new ItemTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(_loc3_,this._xmllist[this._index]);
               this.list.add(_loc3_.TemplateID,_loc3_);
               _loc2_++;
               continue;
            }
            this._timer.removeEventListener(TimerEvent.TIMER,this.__partexceute);
            this._timer.stop();
            this._timer = null;
            onAnalyzeComplete();
            return;
         }
      }
   }
}
