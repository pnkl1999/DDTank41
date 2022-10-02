package serverlist.view
{
   import com.pickgliss.ui.ComponentFactory;
   
   public class RoomListServerDropList extends ServerDropList
   {
       
      
      public function RoomListServerDropList()
      {
         super();
      }
      
      override protected function initView() : void
      {
         _bg = ComponentFactory.Instance.creat("asset.serverlist.RoomListBG");
         addChild(_bg);
         _cb = ComponentFactory.Instance.creat("serverlist.room.DropListCombo");
         addChild(_cb);
      }
   }
}
