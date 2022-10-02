package church.view.weddingRoom
{
   import church.controller.ChurchRoomController;
   import church.model.ChurchRoomModel;
   import church.view.churchScene.MoonSceneMap;
   import church.view.churchScene.SceneMap;
   import church.view.churchScene.WeddingSceneMap;
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class WeddingRoomView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZE:Array = [1208,835];
      
      public static const MAP_SIZEII:Array = [2011,1361];
       
      
      private var _controller:ChurchRoomController;
      
      private var _model:ChurchRoomModel;
      
      private var _sceneScene:SceneScene;
      
      private var _sceneMapVO:SceneMapVO;
      
      private var _sceneMap:SceneMap;
      
      private var _chatFrame:Sprite;
      
      private var _weddingRoomMenuView:WeddingRoomMenuView;
      
      private var _weddingRoomToolView:WeddingRoomToolView;
      
      private var _weddingRoomMask:WeddingRoomMask;
      
      public function WeddingRoomView(param1:ChurchRoomController, param2:ChurchRoomModel)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this._sceneScene = new SceneScene();
         ChatManager.Instance.state = ChatManager.CHAT_WEDDINGROOM_STATE;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         this._weddingRoomMenuView = new WeddingRoomMenuView(this._model);
         addChild(this._weddingRoomMenuView);
         this._weddingRoomToolView = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.WeddingRoomToolView");
         this._weddingRoomToolView.controller = this._controller;
         this._weddingRoomToolView.churchRoomModel = this._model;
         addChild(this._weddingRoomToolView);
         this.setMap();
      }
      
      public function setMap(param1:Point = null) : void
      {
         this.clearMap();
         var _loc2_:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(this.getMapRes()) as Class)() as MovieClip;
         var _loc3_:Sprite = _loc2_.getChildByName("entity") as Sprite;
         var _loc4_:Sprite = _loc2_.getChildByName("sky") as Sprite;
         var _loc5_:Sprite = _loc2_.getChildByName("mesh") as Sprite;
         var _loc6_:Sprite = _loc2_.getChildByName("bg") as Sprite;
         this._sceneScene.setHitTester(new PathMapHitTester(_loc5_));
         if(!this._sceneMap)
         {
            this._sceneMap = !!ChurchManager.instance.currentScene ? new MoonSceneMap(this._model,this._sceneScene,this._model.getPlayers(),_loc6_,_loc5_,_loc3_,_loc4_) : new WeddingSceneMap(this._model,this._sceneScene,this._model.getPlayers(),_loc6_,_loc5_,_loc3_,_loc4_);
            addChildAt(this._sceneMap,0);
         }
         this._weddingRoomMenuView.resetView();
         this._weddingRoomToolView.resetView();
         this._sceneMap.sceneMapVO = this.getSceneMapVO();
         if(param1)
         {
            this._sceneMap.sceneMapVO.defaultPos = param1;
         }
         this._sceneMap.addSelfPlayer();
         this._sceneMap.setCenter();
      }
      
      public function movePlayer(param1:int, param2:Array) : void
      {
         if(this._sceneMap)
         {
            this._sceneMap.movePlayer(param1,param2);
         }
      }
      
      public function getSceneMapVO() : SceneMapVO
      {
         var _loc1_:SceneMapVO = new SceneMapVO();
         if(ChurchManager.instance.currentScene)
         {
            _loc1_.mapName = LanguageMgr.GetTranslation("church.churchScene.MoonLightScene");
            _loc1_.mapW = MAP_SIZE[0];
            _loc1_.mapH = MAP_SIZE[1];
            _loc1_.defaultPos = ComponentFactory.Instance.creatCustomObject("church.WeddingRoomView.sceneMapVOPos");
         }
         else
         {
            _loc1_.mapName = LanguageMgr.GetTranslation("church.churchScene.WeddingMainScene");
            _loc1_.mapW = MAP_SIZEII[0];
            _loc1_.mapH = MAP_SIZEII[1];
            _loc1_.defaultPos = ComponentFactory.Instance.creatCustomObject("church.WeddingRoomView.sceneMapVOPosII");
         }
         return _loc1_;
      }
      
      public function useFire(param1:int, param2:int) : void
      {
         this._sceneMap.useFire(param1,param2);
      }
      
      private function clearMap() : void
      {
         if(this._sceneMap)
         {
            if(this._sceneMap.parent)
            {
               this._sceneMap.parent.removeChild(this._sceneMap);
            }
            this._sceneMap.dispose();
         }
         this._sceneMap = null;
      }
      
      public function getMapRes() : String
      {
         return !!ChurchManager.instance.currentScene ? "tank.church.Map02" : "tank.church.Map01";
      }
      
      public function playerWeddingMovie() : void
      {
         this._weddingRoomToolView._toolSendCashBtn.enable = true;
         this.swapChildren(this._weddingRoomMask,this._weddingRoomMenuView);
         addChild(this._chatFrame);
         (this._sceneMap as WeddingSceneMap).playWeddingMovie();
      }
      
      public function switchWeddingView() : void
      {
         if(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
         {
            SoundManager.instance.stopMusic();
            this.readyStartWedding();
         }
         else
         {
            this._weddingRoomMenuView.revertConfig();
            this._weddingRoomMask.showMaskMovie();
            this._weddingRoomMask.addEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__stopWeddingMovie);
         }
         this._weddingRoomMenuView.resetView();
      }
      
      private function __stopWeddingMovie(param1:Event) : void
      {
         SoundManager.instance.playMusic("3002");
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneView.stopWeddingMovie"));
         this._weddingRoomToolView._toolSendCashBtn.enable = false;
         ChurchManager.instance.closeRefundView();
         if(this._sceneMap is WeddingSceneMap)
         {
            (this._sceneMap as WeddingSceneMap).stopWeddingMovie();
         }
         this._weddingRoomMask.removeEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__stopWeddingMovie);
         this._weddingRoomMask.dispose();
      }
      
      private function readyStartWedding() : void
      {
         this._weddingRoomToolView._toolSendCashBtn.enable = true;
         this._weddingRoomMask = new WeddingRoomMask(this._controller);
         this._weddingRoomMask.addEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__playWeddingMovie);
         addChild(this._weddingRoomMask);
         if(this._weddingRoomToolView && this._weddingRoomToolView.parent)
         {
            this._weddingRoomToolView.parent.removeChild(this._weddingRoomToolView);
            addChild(this._weddingRoomToolView);
         }
      }
      
      private function __playWeddingMovie(param1:Event) : void
      {
         this.playerWeddingMovie();
         this._weddingRoomMenuView.backupConfig();
         this._weddingRoomMask.removeEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__playWeddingMovie);
      }
      
      public function setSaulte(param1:int) : void
      {
         this._sceneMap.setSalute(param1);
      }
      
      public function show() : void
      {
         this._controller.addChild(this);
      }
      
      public function dispose() : void
      {
         if(this._sceneScene)
         {
            this._sceneScene.dispose();
         }
         this._sceneScene = null;
         this._sceneMapVO = null;
         if(this._sceneMap)
         {
            if(this._sceneMap.parent)
            {
               this._sceneMap.parent.removeChild(this._sceneMap);
            }
            this._sceneMap.dispose();
         }
         this._sceneMap = null;
         if(this._chatFrame.parent)
         {
            this._chatFrame.parent.removeChild(this._chatFrame);
         }
         this._chatFrame = null;
         if(this._weddingRoomMenuView)
         {
            if(this._weddingRoomMenuView.parent)
            {
               this._weddingRoomMenuView.parent.removeChild(this._weddingRoomMenuView);
            }
            this._weddingRoomMenuView.dispose();
         }
         this._weddingRoomMenuView = null;
         if(this._weddingRoomToolView)
         {
            if(this._weddingRoomToolView.parent)
            {
               this._weddingRoomToolView.parent.removeChild(this._weddingRoomToolView);
            }
            this._weddingRoomToolView.dispose();
         }
         this._weddingRoomToolView = null;
         if(this._weddingRoomMask)
         {
            this._weddingRoomMask.removeEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__stopWeddingMovie);
            if(this._weddingRoomMask.parent)
            {
               this._weddingRoomMask.parent.removeChild(this._weddingRoomMask);
            }
            this._weddingRoomMask.dispose();
         }
         this._weddingRoomMask = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
