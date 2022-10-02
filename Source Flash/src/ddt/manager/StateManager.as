package ddt.manager
{
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import ddt.states.BaseStateView;
   import ddt.states.FadingBlock;
   import ddt.states.IStateCreator;
   import ddt.states.StateType;
   import ddt.utils.MenoryUtil;
   import ddt.view.chat.ChatBugleView;
   import email.manager.MailManager;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.utils.Dictionary;
   
   public class StateManager
   {
      
      private static var dic:Dictionary;
      
      private static var root:Sprite;
      
      private static var current:BaseStateView;
      
      private static var next:BaseStateView;
      
      private static var _currentStateType:String;
      
      public static var getInGame_Step_1:Boolean = false;
      
      public static var getInGame_Step_2:Boolean = false;
      
      public static var getInGame_Step_3:Boolean = false;
      
      public static var getInGame_Step_4:Boolean = false;
      
      public static var getInGame_Step_5:Boolean = false;
      
      public static var getInGame_Step_6:Boolean = false;
      
      public static var getInGame_Step_7:Boolean = false;
      
      public static var getInGame_Step_8:Boolean = false;
      
      private static var _stage:Stage;
      
      public static var isShowFadingAnimation:Boolean = true;
      
      private static var fadingBlock:FadingBlock;
      
      private static var _creator:IStateCreator;
      
      private static var _data:Object;
      
      private static var _enterType:String;
       
      
      public function StateManager()
      {
         super();
      }
      
      public static function get currentStateType() : String
      {
         return _currentStateType;
      }
      
      public static function set currentStateType(param1:String) : void
      {
         _currentStateType = param1;
      }
      
      public static function get nextState() : BaseStateView
      {
         return next;
      }
      
      public static function setup(param1:Sprite, param2:IStateCreator) : void
      {
         dic = new Dictionary();
         root = param1;
         _creator = param2;
         fadingBlock = new FadingBlock(addNextToStage,showLoading);
      }
      
      public static function setState(param1:String = "default", param2:Object = null, param3:int = 0) : void
      {
         var _loc4_:BaseStateView = getState(param1);
         if(param1 == StateType.ROOM_LIST && current.getType() == StateType.MATCH_ROOM)
         {
            if(getInGame_Step_1 && getInGame_Step_2)
            {
               if(getInGame_Step_3 && !getInGame_Step_4)
               {
                  SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到3之后停止了");
               }
               else if(getInGame_Step_4 && !getInGame_Step_5)
               {
                  SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到4之后停止了");
               }
               else if(getInGame_Step_5 && !getInGame_Step_6)
               {
                  SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到5之后停止了");
               }
               else if(getInGame_Step_6 && !getInGame_Step_7)
               {
                  SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到6之后停止了");
               }
               else if(getInGame_Step_7 && !getInGame_Step_8)
               {
                  SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到7之后停止了");
               }
               getInGame_Step_1 = getInGame_Step_2 = getInGame_Step_3 = getInGame_Step_4 = getInGame_Step_5 = getInGame_Step_6 = getInGame_Step_7 = getInGame_Step_8 = false;
            }
         }
         _data = param2;
         _enterType = param1;
         if(_loc4_)
         {
            setStateImp(_loc4_);
         }
         else
         {
            createStateAsync(param1,createCallbak);
         }
      }
      
      public static function stopImidily() : void
      {
         fadingBlock.stopImidily();
      }
      
      private static function createCallbak(param1:BaseStateView) : void
      {
         if(param1)
         {
            dic[param1.getType()] = param1;
         }
         setStateImp(param1);
      }
      
      private static function setStateImp(param1:BaseStateView) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.getType() != _enterType)
         {
            return false;
         }
         _enterType = "";
         if(param1 == current || next == param1)
         {
            current.refresh();
            return false;
         }
         if(param1.check(currentStateType))
         {
            QueueManager.pause();
            next = param1;
            if(!next.prepared)
            {
               next.prepare();
            }
            ShowTipManager.Instance.removeAllTip();
            LayerManager.Instance.clearnGameDynamic();
            if(current)
            {
               fadingBlock.setNextState(next);
               fadingBlock.update();
            }
            else
            {
               addNextToStage();
            }
            return true;
         }
         return false;
      }
      
      private static function addNextToStage() : void
      {
         QueueManager.resume();
         if(current)
         {
            current.leaving(next);
         }
         var _loc1_:BaseStateView = current;
         current = next;
         currentStateType = current.getType();
         next = null;
         current.enter(_loc1_,_data);
         MenoryUtil.clearMenory();
         root.addChild(current.getView());
         current.addedToStage();
         if(_loc1_)
         {
            if(_loc1_.getView().parent)
            {
               _loc1_.getView().parent.removeChild(_loc1_.getView());
            }
            _loc1_.removedFromStage();
         }
         if(current.goBack())
         {
            fadingBlock.executed = false;
            back();
         }
         EnthrallManager.getInstance().updateEnthrallView();
         ChatBugleView.instance.updatePos();
         MailManager.Instance.isOpenFromBag = false;
      }
      
      private static function showLoading() : void
      {
         if(LoaderSavingManager.hasFileToSave)
         {
         }
      }
      
      public static function back() : void
      {
         var _loc1_:String = null;
         if(current != null)
         {
            _loc1_ = current.getBackType();
            if(_loc1_ != "")
            {
               setState(_loc1_);
            }
         }
      }
      
      public static function getState(param1:String) : BaseStateView
      {
         return dic[param1] as BaseStateView;
      }
      
      public static function createStateAsync(param1:String, param2:Function) : void
      {
         _creator.createAsync(param1,param2);
      }
      
      public static function isExitGame(param1:String) : Boolean
      {
         return param1 != StateType.FIGHTING && param1 != StateType.MISSION_ROOM && param1 != StateType.FIGHT_LIB_GAMEVIEW;
      }
      
      public static function isExitRoom(param1:String) : Boolean
      {
         return param1 != StateType.FIGHTING && param1 != StateType.MATCH_ROOM && param1 != StateType.MISSION_ROOM && param1 != StateType.DUNGEON_ROOM && param1 != StateType.CHALLENGE_ROOM && param1 != StateType.ROOM_LOADING && param1 != StateType.FIGHT_LIB && param1 != StateType.TRAINER;
      }
   }
}
