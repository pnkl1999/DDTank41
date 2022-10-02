package consortion.view.club
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.System;
   import im.IMController;
   
   public class ClubRecordItem extends Sprite implements Disposeable
   {
      
      private static var RECORDITEM_HEIGHT:int = 30;
       
      
      private var _info:*;
      
      private var _type:int;
      
      private var _name:FilterFrameText;
      
      private var _button:BaseButton;
      
      private var _contactChairmanBtn:BaseButton;
      
      private var _copyName:BaseButton;
      
      public function ClubRecordItem(param1:int)
      {
         super();
         this._type = param1;
         this.init();
      }
      
      override public function get height() : Number
      {
         return RECORDITEM_HEIGHT;
      }
      
      private function init() : void
      {
         this._name = ComponentFactory.Instance.creatComponentByStylename("club.recordItem.name");
         if(this._type == ClubRecordList.INVITE)
         {
            this._button = ComponentFactory.Instance.creatComponentByStylename("club.acceptInvent");
         }
         else
         {
            this._button = ComponentFactory.Instance.creatComponentByStylename("club.cancelApply");
            this._contactChairmanBtn = ComponentFactory.Instance.creatComponentByStylename("club.contactChairmanBtn");
            this._copyName = ComponentFactory.Instance.creatComponentByStylename("club.copyNameBtn");
            this._copyName.addEventListener(MouseEvent.CLICK,this.__copyHandler);
            this._contactChairmanBtn.addEventListener(MouseEvent.CLICK,this.__contactChairman);
            addChild(this._contactChairmanBtn);
            addChild(this._copyName);
         }
         addChild(this._name);
         addChild(this._button);
         this._button.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function __copyHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         System.setClipboard(this._info.ChairmanName);
      }
      
      private function __contactChairman(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.alertPrivateFrame(this._info.ChairmanID);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._type == ClubRecordList.INVITE)
         {
            SocketManager.Instance.out.sendConsortiaInvatePass(this._info.ID);
         }
         else
         {
            SocketManager.Instance.out.sendConsortiaTryinDelete(this._info.ID);
         }
      }
      
      public function set info(param1:*) : void
      {
         this._info = param1;
         this._name.text = param1.ConsortiaName;
      }
      
      public function dispose() : void
      {
         this._button.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         if(this._contactChairmanBtn)
         {
            this._contactChairmanBtn.removeEventListener(MouseEvent.CLICK,this.__contactChairman);
            ObjectUtils.disposeObject(this._contactChairmanBtn);
            this._contactChairmanBtn = null;
         }
         if(this._copyName)
         {
            this._copyName.removeEventListener(MouseEvent.CLICK,this.__copyHandler);
            ObjectUtils.disposeObject(this._copyName);
            this._copyName = null;
         }
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._button)
         {
            ObjectUtils.disposeObject(this._button);
         }
         this._button = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
