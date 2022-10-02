package road7th.utils
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class BitmapReader extends EventDispatcher
   {
       
      
      private var loader:Loader;
      
      public var bitmap:Bitmap;
      
      public function BitmapReader()
      {
         super();
      }
      
      public function readByteArray(param1:ByteArray) : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.dataComplete);
         this.loader.loadBytes(param1);
      }
      
      public function dataComplete(param1:Event) : void
      {
         this.bitmap = param1.target.content;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
