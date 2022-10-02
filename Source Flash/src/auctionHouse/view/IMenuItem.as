package auctionHouse.view
{
   import flash.events.IEventDispatcher;
   
   public interface IMenuItem extends IEventDispatcher
   {
       
      
      function get info() : Object;
      
      function get x() : Number;
      
      function get y() : Number;
      
      function set x(param1:Number) : void;
      
      function set y(param1:Number) : void;
      
      function get isOpen() : Boolean;
      
      function set isOpen(param1:Boolean) : void;
      
      function set enable(param1:Boolean) : void;
   }
}
