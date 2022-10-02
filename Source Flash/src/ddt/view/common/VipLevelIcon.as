package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class VipLevelIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const SIZE_BIG:int = 0;
      
      public static const SIZE_SMALL:int = 1;
      
      private static const LEVEL_ICON_CLASSPATH:String = "asset.vipIcon.vipLevel_";
       
      
      private var _juniorIcon:ScaleFrameImage;
      
      private var _seniorIcon:ScaleFrameImage;
      
      private var _level:int = 1;
      
      private var _type:int = 0;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:String;
      
      private var _size:int;
      
      public function VipLevelIcon()
      {
         super();
         this._tipStyle = "ddt.view.tips.OneLineTip";
         this._tipGapV = 10;
         this._tipGapH = 10;
         this._tipDirctions = "7,4,6,5";
         this._size = SIZE_SMALL;
         this._juniorIcon = ComponentFactory.Instance.creatComponentByStylename("core.VipLevelIcon");
         this._seniorIcon = ComponentFactory.Instance.creatComponentByStylename("core.SeniorVipLevelIcon");
         ShowTipManager.Instance.addTip(this);
      }
      
      public function setInfo(param1:BasePlayer, param2:Boolean = true, param3:Boolean = false) : void
      {
         this._level = param1.VIPLevel;
         if(param1.ID == PlayerManager.Instance.Self.ID)
         {
            if(param2)
            {
               if(param3)
               {
                  if(PlayerManager.Instance.Self.typeVIP == BasePlayer.SENIOR_VIP)
                  {
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.upValue0");
                  }
                  else if(PlayerManager.Instance.Self.typeVIP == BasePlayer.JUNIOR_VIP)
                  {
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.upValue1");
                  }
                  else if(PlayerManager.Instance.Self.VIPExp > 0)
                  {
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.upValue2");
                  }
                  else
                  {
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.upValue3");
                  }
               }
               else
               {
                  buttonMode = true;
                  if(PlayerManager.Instance.Self.IsVIP)
                  {
                     if(PlayerManager.Instance.Self.VIPLevel < 9)
                     {
                        this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradDays",PlayerManager.Instance.Self.VIPNextLevelDaysNeeded,PlayerManager.Instance.Self.VIPLevel + 1);
                     }
                     else
                     {
                        this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradFull");
                     }
                  }
                  else if(PlayerManager.Instance.Self.VIPExp == 0)
                  {
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.clickOpen");
                  }
                  else
                  {
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.reduceVipExp",5);
                  }
               }
            }
            else
            {
               mouseEnabled = false;
               mouseChildren = false;
            }
            if(!PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPExp == 0)
            {
               this._level = 0;
            }
            if(!param3)
            {
               addEventListener(MouseEvent.CLICK,this.__showVipFrame);
            }
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,this.__showVipFrame);
            buttonMode = false;
            if(param2)
            {
               this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.otherVipTip",param1.VIPLevel);
            }
            else
            {
               mouseEnabled = false;
               mouseChildren = false;
            }
         }
         this._type = param1.typeVIP;
         this.updateIcon();
      }
      
      private function __showVipFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
      }
      
      private function updateIcon() : void
      {
         DisplayUtils.removeDisplay(this._juniorIcon,this._seniorIcon);
         if(this._size == SIZE_SMALL)
         {
            if(this._type == BasePlayer.SENIOR_VIP)
            {
               this._seniorIcon.setFrame(this._level + 9);
               addChild(this._seniorIcon);
            }
            else if(this._type < BasePlayer.SENIOR_VIP)
            {
               this._juniorIcon.setFrame(this._level + 11);
               addChild(this._juniorIcon);
            }
            else
            {
               this._juniorIcon.setFrame(this._level + 11);
               addChild(this._juniorIcon);
            }
         }
         else if(this._size == SIZE_BIG)
         {
            if(this._type == BasePlayer.SENIOR_VIP)
            {
               this._seniorIcon.setFrame(this._level - 1);
               addChild(this._seniorIcon);
            }
            else if(this._type < BasePlayer.SENIOR_VIP)
            {
               this._juniorIcon.setFrame(this._level + 1);
               addChild(this._juniorIcon);
            }
            else
            {
               this._juniorIcon.setFrame(this._level + 1);
               addChild(this._juniorIcon);
            }
         }
      }
      
      public function setSize(param1:int) : void
      {
         this._size = param1;
         this.updateIcon();
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as String;
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.CLICK,this.__showVipFrame);
         ObjectUtils.disposeObject(this._juniorIcon);
         this._juniorIcon = null;
         ObjectUtils.disposeObject(this._seniorIcon);
         this._seniorIcon = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
