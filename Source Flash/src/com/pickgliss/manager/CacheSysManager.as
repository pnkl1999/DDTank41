package com.pickgliss.manager
{
   import com.pickgliss.action.IAction;
   import com.pickgliss.action.TickOrderQueueAction;
   import flash.utils.Dictionary;
   
   public class CacheSysManager
   {
      
      private static var instance:CacheSysManager;
      
      private static var _lockDic:Dictionary = new Dictionary();
       
      
      private var _cacheDic:Dictionary;
      
      public function CacheSysManager()
      {
         super();
         this._cacheDic = new Dictionary();
         _lockDic = new Dictionary();
      }
      
      public static function getInstance() : CacheSysManager
      {
         if(instance == null)
         {
            instance = new CacheSysManager();
         }
         return instance;
      }
      
      private static function getReleaseAction(param1:Array, param2:uint = 0) : IAction
      {
         return new TickOrderQueueAction(param1,100,param2);
      }
      
      public static function lock(param1:String) : void
      {
         _lockDic[param1] = true;
      }
      
      public static function unlock(param1:String) : void
      {
         delete _lockDic[param1];
      }
      
      public static function isLock(param1:String) : Boolean
      {
         return !!Boolean(_lockDic[param1]) ? Boolean(Boolean(true)) : Boolean(Boolean(false));
      }
      
      public function cache(param1:String, param2:IAction) : void
      {
         if(!this._cacheDic[param1])
         {
            this._cacheDic[param1] = new Array();
         }
         this._cacheDic[param1].push(param2);
      }
      
      public function release(param1:String, param2:uint = 0) : void
      {
         var _loc3_:IAction = null;
         if(this._cacheDic[param1])
         {
            _loc3_ = getReleaseAction(this._cacheDic[param1] as Array,param2);
            _loc3_.act();
            delete this._cacheDic[param1];
         }
      }
      
      public function singleRelease(param1:String) : void
      {
         var _loc3_:Array = null;
         if(this._cacheDic[param1])
         {
            _loc3_ = this._cacheDic[param1];
            if(_loc3_[0])
            {
               (_loc3_[0] as IAction).act();
            }
            _loc3_.shift();
         }
      }
      
      public function cacheFunction(param1:String, param2:IAction) : void
      {
         if(!this._cacheDic[param1])
         {
            this._cacheDic[param1] = new Array();
         }
         this._cacheDic[param1].push(param2);
      }
   }
}
