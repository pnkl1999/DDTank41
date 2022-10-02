package ddt.interfaces
{
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Sprite;
   import flash.events.IEventDispatcher;
   
   public interface ICell extends IEventDispatcher, IDragable, IAcceptDrag, ITipedDisplay
   {
       
      
      function set info(param1:ItemTemplateInfo) : void;
      
      function get info() : ItemTemplateInfo;
      
      function getContent() : Sprite;
      
      function dispose() : void;
      
      function get locked() : Boolean;
      
      function set locked(param1:Boolean) : void;
   }
}
