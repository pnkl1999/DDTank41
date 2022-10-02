package socialContact.copyBitmap
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class CopyBitmapMode extends EventDispatcher
   {
      
      public static const CHANGE_MODE:String = "change_mode";
       
      
      public var ponitID:int;
      
      private var _startX:int;
      
      private var _startY:int;
      
      private var _endX:int;
      
      private var _endY:int;
      
      public function CopyBitmapMode()
      {
         super();
      }
      
      public function set startX(param1:int) : void
      {
         this._startX = param1;
         dispatchEvent(new Event(CHANGE_MODE));
      }
      
      public function get startX() : int
      {
         return this._startX;
      }
      
      public function set startY(param1:int) : void
      {
         this._startY = param1;
         dispatchEvent(new Event(CHANGE_MODE));
      }
      
      public function get startY() : int
      {
         return this._startY;
      }
      
      public function set endX(param1:int) : void
      {
         this._endX = param1;
         dispatchEvent(new Event(CHANGE_MODE));
      }
      
      public function get endX() : int
      {
         return this._endX;
      }
      
      public function set endY(param1:int) : void
      {
         this._endY = param1;
         dispatchEvent(new Event(CHANGE_MODE));
      }
      
      public function get endY() : int
      {
         return this._endY;
      }
   }
}
