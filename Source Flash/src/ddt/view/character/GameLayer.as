package ddt.view.character
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   
   public class GameLayer extends BaseLayer
   {
       
      
      private var _state:String = "";
      
      public function GameLayer(param1:ItemTemplateInfo, param2:String, param3:Boolean = false, param4:int = 1, param5:String = null, param6:String = "")
      {
         this._state = param6;
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function getUrl(param1:int) : String
      {
         return PathManager.solveGoodsPath(_info.CategoryID,_pic,_info.NeedSex == 1,BaseLayer.GAME,_hairType,String(param1),info.Level,_gunBack,int(_info.Property1),this._state);
      }
   }
}
