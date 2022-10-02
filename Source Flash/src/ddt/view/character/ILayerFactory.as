package ddt.view.character
{
   import ddt.data.goods.ItemTemplateInfo;
   
   public interface ILayerFactory
   {
       
      
      function createLayer(param1:ItemTemplateInfo, param2:Boolean, param3:String = "", param4:String = "show", param5:Boolean = false, param6:int = 1, param7:String = null, param8:String = "") : ILayer;
   }
}
