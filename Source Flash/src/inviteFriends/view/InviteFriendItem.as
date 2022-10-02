package inviteFriends.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class InviteFriendItem extends Sprite implements Disposeable
   {
       
      
      private var _title:FilterFrameText;
      
      private var _rewardList:Array;
      
      private var _rewardBnt:BaseButton;
      
      private var _rewardBntOk:BaseButton;
      
      private var _rewardBox:HBox;
      
      private var _rewardBntMc:MovieClip;
      
      public var id:int;
      
      public function InviteFriendItem()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._title = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainView.rewardTitleTxt");
         addChild(this._title);
         this._rewardBox = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainView.rewardHBox");
         addChild(this._rewardBox);
         this._rewardBntMc = ComponentFactory.Instance.creat("inviteFriendsMainView.rewardBntMc");
         PositionUtils.setPos(this._rewardBntMc,"inviteFriendsMainView.rewardBntMcPos");
         this._rewardBntMc.visible = false;
         addChild(this._rewardBntMc);
         this._rewardBnt = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainView.rewardBnt");
         addChild(this._rewardBnt);
         this._rewardBntOk = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainView.rewardBntOk");
         addChild(this._rewardBntOk);
         this._rewardBntOk.enable = false;
         this._rewardBntOk.visible = false;
      }
      
      public function visibleRewardBnt(param1:Boolean) : void
      {
         if(param1)
         {
            this._rewardBnt.enable = true;
            this._rewardBntMc.visible = true;
         }
         else
         {
            this._rewardBnt.enable = false;
            this._rewardBntMc.visible = false;
         }
      }
      
      public function changeRewardBnt(param1:Boolean) : void
      {
         if(param1)
         {
            this._rewardBntOk.visible = true;
            this._rewardBnt.visible = false;
            this._rewardBntMc.visible = false;
            this._rewardBntOk.enable = false;
         }
         else
         {
            this._rewardBntOk.visible = false;
         }
      }
      
      public function setTitle(param1:String) : void
      {
         this._title.text = param1;
      }
      
      public function setRewardList(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ItemTemplateInfo = null;
         var _loc4_:InviteFriendItemCell = null;
         var _loc5_:DaylyGiveInfo = null;
         if(param1.length == 0)
         {
            return;
         }
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            _loc5_ = param1[_loc6_] as DaylyGiveInfo;
            _loc2_ = _loc5_.TemplateID;
            _loc3_ = ItemManager.Instance.getTemplateById(_loc2_);
            _loc4_ = new InviteFriendItemCell(0,_loc3_);
            _loc4_.count = _loc5_.Count;
            _loc4_.updateCount();
            _loc4_.mouseOverEffBoolean = false;
            this._rewardBox.addChild(_loc4_);
            _loc6_++;
         }
      }
      
      private function addEvent() : void
      {
         this._rewardBnt.addEventListener(MouseEvent.CLICK,this._rewardBntClick);
      }
      
      private function _rewardBntClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.inviteFriendRewardBntClick(this.id);
      }
      
      private function removeEvent() : void
      {
         this._rewardBnt.removeEventListener(MouseEvent.CLICK,this._rewardBntClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(numChildren)
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}
