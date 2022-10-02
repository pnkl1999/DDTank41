package ddt.view.character
{
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   
   public interface ILayer extends IColorEditable
   {
       
      
      function get info() : ItemTemplateInfo;
      
      function set info(param1:ItemTemplateInfo) : void;
      
      function getContent() : DisplayObject;
      
      function dispose() : void;
      
      function load(param1:Function) : void;
      
      function set currentEdit(param1:int) : void;
      
      function get currentEdit() : int;
      
      function get width() : Number;
      
      function get height() : Number;
      
      function get isComplete() : Boolean;
   }
}
