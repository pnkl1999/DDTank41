<?php

namespace Models;

use Illuminate\Database\Eloquent\Model;

class MemHistory extends Model
{
    protected $table='Mem_History';
    
    protected $primaryKey='ServerID';
    
    public $timestamps = false;
    
    protected $guarded = ['ServerID'];
}