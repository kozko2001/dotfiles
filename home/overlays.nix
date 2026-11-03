self: super: {
  # pyopenjtalk-plus's pytest suite has one failing test: it expects a
  # "must be str" TypeError, but the extension raises "Expected str, got int".
  # That broke piper-tts -> calibre, so skip the check for this package.
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (pyself: pysuper: {
      pyopenjtalk-plus = pysuper.pyopenjtalk-plus.overridePythonAttrs (_: {
        doCheck = false;
      });
    })
  ];
}
