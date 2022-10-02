package serverlist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.ServerInfo;
   import ddt.manager.ServerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ServerDropListItem extends Sprite
   {
       
      
      private var _info:ServerInfo;
      
      protected var _text:FilterFrameText;
      
      public function ServerDropListItem()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._text = ComponentFactory.Instance.creat("serverlist.hall.ServerNameText");
         addChild(this._text);
      }
      
      public function set info(param1:ServerInfo) : void
      {
         this._info = param1;
         this._text.text = this._info.Name;
         addEventListener(MouseEvent.CLICK,this.__onClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         ServerManager.Instance.connentServer(this._info);
      }
      
      private function __onMouseOver(param1:MouseEvent) : void
      {
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         this._text.background = true;
         this._text.textFormatStyle = "serverlist.ServerNameTextFormatHover";
      }
      
      private function __onMouseOut(param1:MouseEvent) : void
      {
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         this._text.background = false;
         this._text.textFormatStyle = "serverlist.ServerNameTextFormat";
      }
   }
}
