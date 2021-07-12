program SimpleTest;

{$include CompilerOptions.inc}

{$AppType Console}

{$R *.res}

uses
  //WinMemMgr,
  //MemTest,
  //CorrectLocale,
  Stacktrace,
  Windows,
  SysUtils;

// IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE = $8000: Terminal server aware
// IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE = $40: Address Space Layout Randomization (ASLR) enabled
// IMAGE_DLLCHARACTERISTICS_NX_COMPAT = $100: Data Execution Prevention (DEP) enabled
{$SetPeOptFlags $8140}

// IMAGE_FILE_LARGE_ADDRESS_AWARE: may use heap/code above 2GB
{$SetPeFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}


 //===================================================================================================================
 // the compiler will generate code at the call site for this
 //===================================================================================================================
procedure Something;
begin
end;


 //===================================================================================================================
 //===================================================================================================================
procedure TestDelpiException;
var
  AcquiredException: TObject;
begin
  Something;
  try

	try
	  try
		raise Exception.Create('Exception #1');
	  finally
		Something;
	  end;
	except
	  raise;
    end;

	Something;
  except
	on e: Exception do begin
	  Writeln(e.Message, ': Exception "', e.ClassName, '"');
	  Writeln(e.StackTrace);

	  try
		Something;

		try
		  Something;

		  try

			try
			  raise Exception.Create('Exception #2');
			except
			  // test situation when AcquireExceptionObject is used:
			  AcquiredException := System.AcquireExceptionObject;
			end;

			Something;
			// reraise the catched exception:
			raise AcquiredException;

		  finally
			Something;
		  end;

		  Something;
		except
		  raise;
		end;

		Something;
	  except
		on e: Exception do begin
		  Writeln(e.Message, ': Exception "', e.ClassName, '"');
		  Writeln(e.StackTrace);
		end;
	  end;

	end;
  end;
  Something;
end;


 //===================================================================================================================
 //===================================================================================================================
procedure TestOsException;

  function _GetZero: integer;
  begin
	Result := 0;
  end;

var
  AcquiredException: TObject;
begin
  Something;
  try

	try
	  try
		Writeln(1 div _GetZero);	// force exception
	  finally
		Something;
	  end;
	except
	  raise;
    end;

	Something;
  except
	on e: Exception do begin
	  Writeln(e.Message, ': Exception "', e.ClassName, '"');
	  Writeln(e.StackTrace);

	  try
		Something;

		try
		  Something;

		  try
			// Compiler cannot know that the division always throws an exception:
			AcquiredException := nil;

			try
			  Writeln(1 div _GetZero);	// force exception
			except
			  // test situation when AcquireExceptionObject is used:
			  AcquiredException := System.AcquireExceptionObject;
			end;

			Something;
			// reraise the catched exception:
			raise AcquiredException;

		  finally
			Something;
		  end;

		  Something;
		except
		  raise;
		end;

		Something;
	  except
		on e: Exception do begin
		  Writeln(e.Message, ': Exception "', e.ClassName, '"');
		  Writeln(e.StackTrace);
		end;
	  end;

	end;
  end;
  Something;
end;


 //===================================================================================================================
 //===================================================================================================================
procedure TestEAccessViolation;
var
  AcquiredException: TObject;
begin
  Something;
  try

	try
	  try
		PByte(nil)[20] := 0;	// force exception
	  finally
		Something;
	  end;
	except
	  raise;
    end;

	Something;
  except
	on e: Exception do begin
	  Writeln(e.Message, ': Exception "', e.ClassName, '"');
	  Writeln(e.StackTrace);

	  try
		Something;

		try
		  Something;

		  try
			// Compiler cannot know that the division always throws an exception:
			AcquiredException := nil;

			try
			  PByte(nil)[20] := 0;	// force exception
			except
			  // test situation when AcquireExceptionObject is used:
			  AcquiredException := System.AcquireExceptionObject;
			end;

			Something;
			// reraise the catched exception:
			raise AcquiredException;

		  finally
			Something;
		  end;

		  Something;
		except
		  raise;
		end;

		Something;
	  except
		on e: Exception do begin
		  Writeln(e.Message, ': Exception "', e.ClassName, '"');
		  Writeln(e.StackTrace);
		end;
	  end;

	end;
  end;
  Something;
end;


 //===================================================================================================================
 //===================================================================================================================
procedure Test2;
var
  hMod: HMODULE;
begin

  TestDelpiException;

  Writeln('~~~~~~~~~~~~');

  // verifying DLL unload detection: load and unload a DLL *not* currently loaded by the process:
  hMod := Windows.LoadLibrary('hid.dll');
  Assert(hMod <> 0);
  Windows.FreeLibrary(hMod);

  TestOsException;

  Writeln('~~~~~~~~~~~~');

  // verifying DLL unload detection: load and unload a DLL *not* currently loaded by the process:
  hMod := Windows.LoadLibrary('hid.dll');
  Assert(hMod <> 0);
  Windows.FreeLibrary(hMod);

  TestEAccessViolation;
end;


 //===================================================================================================================
 //===================================================================================================================
procedure Test1;
begin
  try
	Writeln('Stacktrace without exception:');
	Writeln(TStackTraceHlp.GetStackTrace);

	Test2;
  finally
//	Test2;
  end;
end;


begin
  Test1;

  Readln;
end.

