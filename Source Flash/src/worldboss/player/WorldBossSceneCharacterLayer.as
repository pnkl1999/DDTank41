package worldboss.player
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.view.character.BaseLayer;
   import worldboss.WorldBossManager;
   
   public class WorldBossSceneCharacterLayer extends BaseLayer
   {
       
      
      private var _direction:int;
      
      private var _sex:Boolean;
      
      public function WorldBossSceneCharacterLayer(param1:ItemTemplateInfo, param2:String = "", param3:int = 1, param4:Boolean = true)
      {
         this._direction = param3;
         this._sex = param4;
         super(param1,param2);
      }
      
      override protected function getUrl(param1:int) : String
      {
         var _loc2_:String = this._direction == 1 ? "clothF" : (this._direction == 2 ? "cloth" : "clothF");
         return WorldBossManager.Instance.getWorldbossResource() + "/cloth/" + (!!this._sex ? "M" : "F") + "/" + _loc2_ + "/" + String(param1) + ".png";
      }
   }
}
