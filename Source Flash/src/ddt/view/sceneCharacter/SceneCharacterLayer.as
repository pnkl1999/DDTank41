package ddt.view.sceneCharacter
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import ddt.view.character.BaseLayer;
   
   public class SceneCharacterLayer extends BaseLayer
   {
       
      
      private var _direction:int;
      
      private var _sceneCharacterLoaderPath:String;
      
      private var _sex:Boolean;
      
      public function SceneCharacterLayer(param1:ItemTemplateInfo, param2:String = "", param3:int = 1, param4:Boolean = true, param5:String = "")
      {
         this._direction = param3;
         this._sceneCharacterLoaderPath = param5;
         this._sex = param4;
         super(param1,param2);
      }
      
      override protected function getUrl(param1:int) : String
      {
         return PathManager.solveSceneCharacterLoaderPath(_info.CategoryID,_info.Pic,this._sex,_info.NeedSex == 1,String(param1),this._direction,this._sceneCharacterLoaderPath);
      }
   }
}
