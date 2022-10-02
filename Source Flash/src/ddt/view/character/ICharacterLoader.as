package ddt.view.character
{
   public interface ICharacterLoader
   {
       
      
      function setFactory(param1:ILayerFactory) : void;
      
      function getContent() : Array;
      
      function load(param1:Function = null) : void;
      
      function update() : void;
      
      function dispose() : void;
   }
}
