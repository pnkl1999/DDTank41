package ddt.view.character
{
   import ddt.data.player.PlayerInfo;
   
   public class CharacterLoaderFactory implements ICharacterLoaderFactory
   {
      
      public static const SHOW:String = "show";
      
      public static const GAME:String = "game";
      
      public static const ROOM:String = "room";
      
      public static const CONSORTIA:String = "consortia";
       
      
      public function CharacterLoaderFactory()
      {
         super();
      }
      
      public function createLoader(param1:PlayerInfo, param2:String = "show") : ICharacterLoader
      {
         var _loc3_:ICharacterLoader = null;
         switch(param2)
         {
            case SHOW:
               _loc3_ = new ShowCharacterLoader(param1);
               break;
            case GAME:
               _loc3_ = new GameCharacterLoader(param1);
               break;
            case ROOM:
               _loc3_ = new RoomCharaterLoader(param1);
         }
         if(_loc3_ != null)
         {
            _loc3_.setFactory(LayerFactory.instance);
         }
         return _loc3_;
      }
   }
}
