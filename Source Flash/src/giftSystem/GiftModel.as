package giftSystem
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class GiftModel extends EventDispatcher
   {
       
      
      public function GiftModel(param1:IEventDispatcher = null)
      {
         super(param1);
         this.init();
      }
      
      private function init() : void
      {
      }
   }
}
