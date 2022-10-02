package church.view.menu
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MenuPanel extends Sprite
   {
      
      public static const STARTPOS:int = 10;
      
      public static const STARTPOS_OFSET:int = 18;
      
      public static const GUEST_X:int = 9;
      
      public static const THIS_X_OFSET:int = 95;
      
      public static const THIS_Y_OFSET:int = 55;
       
      
      private var _info:PlayerInfo;
      
      private var _kickGuest:MenuItem;
      
      private var _blackGuest:MenuItem;
      
      private var _bg:Scale9CornerImage;
      
      public function MenuPanel()
      {
         var _loc1_:Number = NaN;
         _loc1_ = NaN;
         super();
         this._bg = ComponentFactory.Instance.creat("church.weddingRoom.guestListMenuBg");
         addChildAt(this._bg,0);
         _loc1_ = STARTPOS;
         this._kickGuest = new MenuItem(LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.exitRoom"));
         this._kickGuest.x = GUEST_X;
         this._kickGuest.y = _loc1_;
         _loc1_ += STARTPOS_OFSET;
         this._kickGuest.addEventListener("menuClick",this.__menuClick);
         addChild(this._kickGuest);
         this._blackGuest = new MenuItem(LanguageMgr.GetTranslation("tank.menu.AddBlack"));
         this._blackGuest.x = GUEST_X;
         this._blackGuest.y = _loc1_;
         _loc1_ += STARTPOS_OFSET;
         this._blackGuest.addEventListener("menuClick",this.__menuClick);
         addChild(this._blackGuest);
         graphics.beginFill(0,0);
         graphics.drawRect(-3000,-3000,6000,6000);
         graphics.endFill();
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         this._info = param1;
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.hide();
      }
      
      private function __menuClick(param1:Event) : void
      {
         if(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.menu.MenuPanel.menuClick"));
            return;
         }
         if(this._info)
         {
            switch(param1.currentTarget)
            {
               case this._kickGuest:
                  SocketManager.Instance.out.sendChurchKick(this._info.ID);
                  break;
               case this._blackGuest:
                  SocketManager.Instance.out.sendChurchForbid(this._info.ID);
            }
         }
      }
      
      public function show() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
         if(stage && parent)
         {
            _loc1_ = parent.globalToLocal(new Point(stage.mouseX,stage.mouseY));
            this.x = _loc1_.x;
            this.y = _loc1_.y;
            if(x + THIS_X_OFSET > stage.stageWidth)
            {
               this.x = x - THIS_X_OFSET;
            }
            if(y + THIS_Y_OFSET > stage.stageHeight)
            {
               y = stage.stageHeight - THIS_Y_OFSET;
            }
         }
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         this._blackGuest.removeEventListener("menuClick",this.__menuClick);
         this._info = null;
         if(this._kickGuest && this._kickGuest.parent)
         {
            this._kickGuest.parent.removeChild(this._kickGuest);
         }
         if(this._kickGuest)
         {
            this._kickGuest.dispose();
         }
         this._kickGuest = null;
         if(this._blackGuest && this._blackGuest.parent)
         {
            this._blackGuest.parent.removeChild(this._blackGuest);
         }
         if(this._blackGuest)
         {
            this._blackGuest.dispose();
         }
         this._blackGuest = null;
         if(this._bg)
         {
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.dispose();
         }
         this._bg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
