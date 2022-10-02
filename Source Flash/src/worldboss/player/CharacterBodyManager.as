package worldboss.player
{
   import flash.events.EventDispatcher;
   
   public class CharacterBodyManager extends EventDispatcher
   {
      
      private static var _instance:CharacterBodyManager;
       
      
      private var _sceneBoyCharacterLoaderBody:SceneCharacterLoaderBody;
      
      private var _sceneGirlCharaterLoaderBody:SceneCharacterLoaderBody;
      
      private var _sceneCharacterLoaderPath:String;
      
      private var _isLoaderBoyBodySucess:Boolean = false;
      
      private var _isLoaderGirlBodySucess:Boolean = false;
      
      public function CharacterBodyManager()
      {
         super();
      }
   }
}
