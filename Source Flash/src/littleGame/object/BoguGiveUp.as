package littleGame.object
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.SoundManager;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import littleGame.LittleGameManager;
   import littleGame.data.LittleObjectInvoke;
   import littleGame.data.LittleObjectType;
   import littleGame.interfaces.ILittleObject;
   import littleGame.model.LittleLiving;
   import littleGame.model.Scenario;
   import littleGame.view.InhaleNoteShape;
   import road7th.comm.PackageIn;
   
   public class BoguGiveUp extends Sprite implements ILittleObject
   {
      
      private static var MaxNoteCount:int = 3;
      
      public static var NoteCount:int = 0;
       
      
      private var _giveup:MovieClip;
      
      private var _scene:Scenario;
      
      private var _id:int;
      
      private var _target:LittleLiving;
      
      private var _maxInhaleCount:int = 5;
      
      private var _inhaleCount:int = 0;
      
      private var _noteShape:InhaleNoteShape;
      
      public function BoguGiveUp()
      {
         super();
      }
      
      public function get type() : String
      {
         return LittleObjectType.BoguGiveup;
      }
      
      public function initialize(scene:Scenario, pkg:PackageIn) : void
      {
         this._scene = scene;
         this._id = pkg.readInt();
         this._target = this._scene.findLiving(pkg.readInt());
         this._maxInhaleCount = pkg.readInt();
         this.execute();
      }
      
      private function drawNote(count:int, max:int) : void
      {
         if(this._noteShape)
         {
            this._noteShape.setNote(count,max);
         }
         else
         {
            this._noteShape = new InhaleNoteShape(count,max);
            addChild(this._noteShape);
            this._noteShape.x = StageReferance.stageWidth - this._noteShape.width >> 1;
            this._noteShape.y = 20;
         }
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function execute() : void
      {
         var idx:int = 0;
         this._scene.selfInhaled = true;
         this.drawNote(this._inhaleCount,this._maxInhaleCount);
         StageReferance.stage.focus = null;
         var g:Graphics = graphics;
         g.beginFill(0,0);
         g.drawRect(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
         g.endFill();
         if(LittleGameManager.Instance.mainStage.contains(ChatManager.Instance.view))
         {
            idx = LittleGameManager.Instance.mainStage.getChildIndex(ChatManager.Instance.view);
            LittleGameManager.Instance.mainStage.addChildAt(this,idx);
         }
         else
         {
            LittleGameManager.Instance.mainStage.addChild(this);
         }
         this._giveup = ClassUtils.CreatInstance("asset.littlegame.bogu.giveup");
         this._giveup.x = 814;
         this._giveup.y = 566;
         this._giveup.gotoAndPlay("in");
         this._giveup.buttonMode = true;
         this._giveup.mouseChildren = false;
         addChild(this._giveup);
         this.addEvent();
      }
      
      public function invoke(pkg:PackageIn) : void
      {
         var command:int = pkg.readInt();
         if(command == LittleObjectInvoke.UpdateInhaleCount && NoteCount < MaxNoteCount)
         {
            this._maxInhaleCount = pkg.readInt();
            this._inhaleCount = pkg.readInt();
            this.drawNote(this._inhaleCount,this._maxInhaleCount);
         }
      }
      
      private function addEvent() : void
      {
         this._giveup.addEventListener(MouseEvent.CLICK,this.__giveup);
         this._giveup.addEventListener(MouseEvent.MOUSE_OVER,this.__giveupOver);
         this._giveup.addEventListener(MouseEvent.MOUSE_OUT,this.__giveupOut);
      }
      
      private function __giveupOut(event:MouseEvent) : void
      {
         if(this._giveup)
         {
            this._giveup.gotoAndStop("up");
         }
      }
      
      private function __giveupOver(event:MouseEvent) : void
      {
         if(this._giveup)
         {
            this._giveup.gotoAndStop("over");
         }
      }
      
      private function __giveup(event:MouseEvent) : void
      {
         event.stopPropagation();
         this._giveup.removeEventListener(MouseEvent.CLICK,this.__giveup);
         this._giveup.removeEventListener(MouseEvent.MOUSE_OVER,this.__giveupOver);
         this._giveup.removeEventListener(MouseEvent.MOUSE_OUT,this.__giveupOut);
         this._giveup.removeEventListener(Event.ENTER_FRAME,this.__giveupFrame);
         this._giveup.mouseEnabled = false;
         this._giveup.addEventListener(Event.ENTER_FRAME,this.__giveupFrame);
         this._giveup.gotoAndPlay("out");
         SoundManager.instance.play("160");
         this._scene.selfPlayer.doAction("stand");
      }
      
      private function __giveupFrame(event:Event) : void
      {
         var movie:MovieClip = event.currentTarget as MovieClip;
         if(movie.currentFrame >= movie.totalFrames)
         {
            movie.removeEventListener(Event.ENTER_FRAME,this.__giveupFrame);
            movie.stop();
            this.complete();
         }
      }
      
      private function complete() : void
      {
         LittleGameManager.Instance.cancelInhaled(this._target.id);
         this._scene.removeObject(this);
      }
      
      private function removeEvent() : void
      {
         this._giveup.removeEventListener(MouseEvent.CLICK,this.__giveup);
         this._giveup.removeEventListener(MouseEvent.MOUSE_OVER,this.__giveupOver);
         this._giveup.removeEventListener(MouseEvent.MOUSE_OUT,this.__giveupOut);
         this._giveup.removeEventListener(Event.ENTER_FRAME,this.__giveupFrame);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._giveup);
         this._giveup = null;
         ObjectUtils.disposeObject(this._noteShape);
         this._noteShape = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
