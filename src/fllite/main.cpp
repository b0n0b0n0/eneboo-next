#endif

#if defined(Q_OS_WIN32)
  appFont.setFamily(FLSettings::readEntry("font/family", "Tahoma"));
#endif

#if defined(Q_OS_MACX)
  appFont.setFamily(FLSettings::readEntry("font/family", "Lucida Grande"));
  pointSize = 12;
  QString envPath(getenv("PATH"));
  envPath = "/sw/sbin:/sw/bin:" + envPath + ":/usr/X11R6/bin";
  setenv("PATH", envPath.local8Bit(), 1);
#endif

  appFont.setPointSize(FLSettings::readNumEntry("font/pointSize", pointSize));
  appFont.setBold(FLSettings::readBoolEntry("font/bold", false));
  appFont.setItalic(FLSettings::readBoolEntry("font/italic", false));
  appFont.setUnderline(FLSettings::readBoolEntry("font/underline", false));
  appFont.setStrikeOut(FLSettings::readBoolEntry("font/strikeOut", false));

  AbanQ->setFont(appFont);
  AbanQ->setStyle(FLSettings::readEntry("style", "QtCurve"));

  AbanQ->installTranslator(AbanQ->createSysTranslator(QString(QTextCodec::locale()).left(2), true));
  AbanQ->installTranslator(AbanQ->createSysTranslator("multilang"));
  AbanQ->setPalette(p, true);

  FLConnectDBDialog *s = 0;
  QSplashScreen *splash = 0;

  if (silentConn.isEmpty()) {
    bool autoLogin = FLSettings::readBoolEntry("application/autoLogin", autoLogin_);
    s = new FLConnectDBDialog(autoLogin, 0, "FLConnectDBDialog", 0, strConn);

    static_cast<QWidget *>(s->child("frMore"))->hide();
    s->adjustSize();
    s->setPalette(p);
    int ret = -1;
    bool connectAttempted = false;

    do {
      if (!s->isShown()) {
        s->show();
        s->raise();
      }
      if (autoLogin && !connectAttempted) {
        QTimer::singleShot(1000, s, SLOT(tryConnect()));
        connectAttempted = true;
      } else
        s->exec();
    } while (s->error());

    ret = s->result();
    QTimer::singleShot(0, s, SLOT(deleteLater()));

    if (ret != QDialog::Accepted) {
      QTimer::singleShot(0, AbanQ, SLOT(quit()));
      return;
    }
    //Buscamos splashScreen Externo
    QImage img(AQ_PREFIX + "/share/eneboo/splashscreen.png");
      if(!img.isNull()) // Load succeded ?
             splash = new QSplashScreen(QPixmap(img)); 
               else
#ifndef FL_QUICK_CLIENT
 splash = new QSplashScreen(QPixmap::fromMimeSource("splashdebugger.png"));
#else
 splash = new QSplashScreen(QPixmap::fromMimeSource("splashclient.png"));
#endif
    splash->show();
    splash->message(QT_TR_NOOP("Inicializando..."), Qt::AlignRight, QColor(255, 255, 255));