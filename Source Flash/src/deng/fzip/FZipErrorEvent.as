package deng.fzip
{
   import flash.events.Event;
   
   public class FZipErrorEvent extends Event
   {
      
      public static const PARSE_ERROR:String = "parseError";
       
      
      public var text:String;
      
      public function FZipErrorEvent(param1:String, param2:String = "", param3:Boolean = false, param4:Boolean = false)
      {
         this.text = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new FZipErrorEvent(type,this.text,bubbles,cancelable);
      }
   }
}
