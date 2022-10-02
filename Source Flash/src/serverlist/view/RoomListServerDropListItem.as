package serverlist.view
{
   import com.pickgliss.ui.ComponentFactory;
   
   public class RoomListServerDropListItem extends ServerDropListItem
   {
       
      
      public function RoomListServerDropListItem()
      {
         super();
      }
      
      override protected function initView() : void
      {
         _text = ComponentFactory.Instance.creat("serverlist.room.ServerNameText");
         addChild(_text);
      }
   }
}
