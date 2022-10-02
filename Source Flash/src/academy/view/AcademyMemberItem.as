package academy.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.AcademyManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class AcademyMemberItem extends Sprite implements Disposeable
   {
       
      
      private var _itemBg:ScaleFrameImage;
      
      private var _OnlineIcon:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _fightPowerTxt:FilterFrameText;
      
      private var _levelIcon:LevelIcon;
      
      private var _info:AcademyPlayerInfo;
      
      private var _selected:Boolean;
      
      private var _sexIcon:SexIcon;
      
      public function AcademyMemberItem()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.itemBg");
         this._itemBg.setFrame(1);
         addChild(this._itemBg);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
         this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.fightPowerTxt");
         addChild(this._fightPowerTxt);
         this._OnlineIcon = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.state_icon");
         this._OnlineIcon.setFrame(2);
         addChild(this._OnlineIcon);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("academy.AcademyMemberItem.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("academy.AcademyMemberItem.SexIcon");
         addChild(this._sexIcon);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseClick);
      }
      
      private function __onMouseClick(param1:MouseEvent) : void
      {
         if(!this._selected)
         {
            this._itemBg.setFrame(1);
         }
      }
      
      private function __onMouseOver(param1:MouseEvent) : void
      {
         if(!this._selected)
         {
            this._itemBg.setFrame(2);
         }
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         this._selected = param1;
         this._itemBg.setFrame(!!this._selected ? int(int(2)) : int(int(1)));
      }
      
      public function get isSelect() : Boolean
      {
         return this._selected;
      }
      
      private function updateComponentPos() : void
      {
         if(this._info.info.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
         {
            this._fightPowerTxt.x = PositionUtils.creatPoint("academy.AcademyMemberListView").x;
            this._levelIcon.x = PositionUtils.creatPoint("academy.AcademyMemberListViewII").x;
         }
         else
         {
            this._fightPowerTxt.x = PositionUtils.creatPoint("academy.AcademyMemberListView").y;
            this._levelIcon.x = PositionUtils.creatPoint("academy.AcademyMemberListViewII").y;
         }
      }
      
      private function updateInfo() : void
      {
         var _loc1_:PlayerInfo = this.info.info;
         this._nameTxt.text = _loc1_.NickName;
         this._fightPowerTxt.text = String(_loc1_.FightPower);
         this._levelIcon.setInfo(_loc1_.Grade,_loc1_.Repute,_loc1_.WinCount,_loc1_.TotalCount,_loc1_.FightPower,_loc1_.Offer,true,false);
         if(_loc1_.playerState.StateID != PlayerState.OFFLINE)
         {
            this._OnlineIcon.setFrame(1);
         }
         else
         {
            this._OnlineIcon.setFrame(2);
         }
         this._sexIcon.setSex(_loc1_.Sex);
         if(_loc1_.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(142,_loc1_.typeVIP);
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this._nameTxt.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._nameTxt);
         }
         else
         {
            addChild(this._nameTxt);
            DisplayUtils.removeDisplay(this._vipName);
         }
      }
      
      public function set info(param1:AcademyPlayerInfo) : void
      {
         this._info = param1;
         this.updateInfo();
         this.updateComponentPos();
      }
      
      public function get info() : AcademyPlayerInfo
      {
         return this._info;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseClick);
         if(this._itemBg)
         {
            ObjectUtils.disposeObject(this._itemBg);
            this._itemBg = null;
         }
         if(this._nameTxt)
         {
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
         }
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
         }
         if(this._fightPowerTxt)
         {
            ObjectUtils.disposeObject(this._fightPowerTxt);
            this._fightPowerTxt = null;
         }
         if(this._levelIcon)
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(this._sexIcon)
         {
            ObjectUtils.disposeObject(this._sexIcon);
            this._sexIcon = null;
         }
         if(this._OnlineIcon)
         {
            ObjectUtils.disposeObject(this._OnlineIcon);
            this._OnlineIcon = null;
         }
      }
   }
}
