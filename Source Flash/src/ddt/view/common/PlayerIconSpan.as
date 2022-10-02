package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.data.player.BasePlayer;
   import ddt.manager.AcademyManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.academyCommon.academyIcon.AcademyIcon;
   import game.GameManager;
   
   public class PlayerIconSpan extends VBox
   {
       
      
      private var _info:BasePlayer;
      
      private var _levelIcon:LevelIcon;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _marriedIcon:MarriedIcon;
      
      private var _academyIcon:AcademyIcon;
      
      public function PlayerIconSpan(param1:BasePlayer)
      {
         this._info = param1;
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:int = 0;
         super.init();
         if(this._info)
         {
            if(this._levelIcon == null)
            {
               this._levelIcon = new LevelIcon();
            }
            this._levelIcon.setSize(LevelIcon.SIZE_BIG);
            _loc1_ = 1;
            if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               _loc1_ = GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) == null ? int(int(-1)) : int(int(GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team));
            }
            this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false,_loc1_);
            addChild(this._levelIcon);
            if(this._info.ID == PlayerManager.Instance.Self.ID || this._info.IsVIP)
            {
               if(this._vipIcon == null)
               {
                  this._vipIcon = new VipLevelIcon();
                  addChild(this._vipIcon);
               }
               this._vipIcon.setInfo(this._info);
               if(!this._info.IsVIP)
               {
                  this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               }
               else
               {
                  this._vipIcon.filters = null;
               }
            }
            else if(this._vipIcon)
            {
               this._vipIcon.dispose();
               this._vipIcon = null;
            }
            if(this._info.SpouseID > 0)
            {
               if(this._marriedIcon == null)
               {
                  this._marriedIcon = new MarriedIcon();
               }
               this._marriedIcon.tipData = {
                  "nickName":this._info.SpouseName,
                  "gender":this._info.Sex
               };
               addChild(this._marriedIcon);
            }
            else if(this._marriedIcon)
            {
               this._marriedIcon.dispose();
               this._marriedIcon = null;
            }
         }
         else
         {
            if(this._levelIcon)
            {
               this._levelIcon.dispose();
               this._levelIcon = null;
            }
            if(this._vipIcon)
            {
               this._vipIcon.dispose();
               this._vipIcon = null;
            }
            if(this._marriedIcon)
            {
               this._marriedIcon.dispose();
               this._marriedIcon = null;
            }
         }
         if(this.getShowAcademyIcon())
         {
            this._academyIcon = new AcademyIcon();
            this._academyIcon.tipData = this._info;
            this._academyIcon.visible = true;
            addChild(this._academyIcon);
         }
         else if(this._academyIcon)
         {
            this._academyIcon.tipData = this._info;
         }
         if(this._marriedIcon)
         {
            if(this._vipIcon)
            {
               this._marriedIcon.y = 150;
            }
            else
            {
               this._marriedIcon.y = 120;
            }
            if(this._academyIcon)
            {
               this._academyIcon.y = this._marriedIcon.y + this._marriedIcon.height + 6;
            }
         }
         else if(this._vipIcon)
         {
            if(this._academyIcon)
            {
               this._academyIcon.y = this._vipIcon.y + this._vipIcon.height + 6;
            }
         }
         else if(this._academyIcon)
         {
            this._academyIcon.y = this._levelIcon.y + this._levelIcon.height + 3;
         }
      }
      
      private function getShowAcademyIcon() : Boolean
      {
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(!this._academyIcon && this._info.apprenticeshipState != AcademyManager.NONE_STATE)
            {
               return true;
            }
            return false;
         }
         if(!this._academyIcon && this._info.ID == PlayerManager.Instance.Self.ID)
         {
            return true;
         }
         if(!this._academyIcon && this._info.ID != PlayerManager.Instance.Self.ID && this._info.apprenticeshipState != AcademyManager.NONE_STATE)
         {
            return true;
         }
         return false;
      }
   }
}
