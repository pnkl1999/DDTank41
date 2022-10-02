package ddt.view.character
{
   import ddt.data.player.PlayerInfo;
   
   public class CharactoryFactory
   {
      
      public static const SHOW:String = "show";
      
      public static const GAME:String = "game";
      
      public static const CONSORTIA:String = "consortia";
      
      public static const ROOM:String = "room";
      
      private static var _characterloaderfactory:ICharacterLoaderFactory = new CharacterLoaderFactory();
       
      
      public function CharactoryFactory()
      {
         super();
      }
      
      public static function createCharacter(param1:PlayerInfo, param2:String = "show", param3:Boolean = false) : ICharacter
      {
         var _loc4_:ICharacter = null;
         switch(param2)
         {
            case SHOW:
               _loc4_ = new ShowCharacter(param1,true,true,param3);
               break;
            case GAME:
               _loc4_ = new GameCharacter(param1);
               break;
            case ROOM:
               _loc4_ = new RoomCharacter(param1);
         }
         if(_loc4_ != null)
         {
            _loc4_.setFactory(_characterloaderfactory);
         }
         return _loc4_;
      }
   }
}
