package ddt.view.character
{
   import ddt.data.player.PlayerInfo;
   
   public interface ICharacterLoaderFactory
   {
       
      
      function createLoader(param1:PlayerInfo, param2:String = "show") : ICharacterLoader;
   }
}
