package ddt.view.character
{
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   
   public class LayerFactory implements ILayerFactory
   {
      
      public static const ICON:String = "icon";
      
      public static const SHOW:String = "show";
      
      public static const GAME:String = "game";
      
      public static const STATE:String = "state";
      
      public static const ROOM:String = "room";
      
      public static const SPECIAL_EFFECT:String = "specialEffect";
      
      private static var _instance:ILayerFactory;
       
      
      public function LayerFactory()
      {
         super();
      }
      
      public static function get instance() : ILayerFactory
      {
         if(_instance == null)
         {
            _instance = new LayerFactory();
         }
         return _instance;
      }
      
      public function createLayer(param1:ItemTemplateInfo, param2:Boolean, param3:String = "", param4:String = "show", param5:Boolean = false, param6:int = 1, param7:String = null, param8:String = "") : ILayer
      {
         var _loc9_:ILayer = null;
         switch(param4)
         {
            case ICON:
               _loc9_ = new IconLayer(param1,param3,param5,param6);
               break;
            case SHOW:
               if(param1)
               {
                  if(param1.CategoryID == EquipType.WING)
                  {
                     _loc9_ = new BaseWingLayer(param1);
                  }
                  else
                  {
                     _loc9_ = new ShowLayer(param1,param3,param5,param6,param7);
                  }
               }
               break;
            case GAME:
               if(param1)
               {
                  if(param1.CategoryID == EquipType.WING)
                  {
                     _loc9_ = new BaseWingLayer(param1,BaseWingLayer.GAME_WING);
                  }
                  else
                  {
                     _loc9_ = new GameLayer(param1,param3,param5,param6,param7,param8);
                  }
               }
               break;
            case STATE:
               _loc9_ = new StateLayer(param1,param2,param3,int(param8));
               break;
            case SPECIAL_EFFECT:
               _loc9_ = new SpecialEffectsLayer(int(param8));
               break;
            case ROOM:
               _loc9_ = new RoomLayer(param1,"",false,1,null,int(param8));
         }
         return _loc9_;
      }
   }
}
