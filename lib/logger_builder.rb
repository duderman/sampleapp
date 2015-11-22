class LoggerBuilder
  LOG_PATH = File.expand_path('../../log', __FILE__)
  DEFAULT_NAME = 'app'
  DEFAULT_OPTIONS = {
    pattern: '[%p:%l] %d :: %c :: %m\n',
    stdout: true,
    file: true,
    level: (ENV['RACK_ENV'] == 'development' ? :debug : :warn)
  }.freeze

  attr_reader :name, :options, :logger

  def initialize(name = DEFAULT_NAME, options = {})
    fail ArgumentError unless name.present?

    @name = name
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def build
    return @logger if @logger

    @logger = Logging.logger[@name]
    append_stdout if options[:stdout]
    append_file if options[:file]
    assign_log_level
    @logger
  end

  private

  def append_stdout
    logger.add_appenders(
      Logging.appenders.stdout(
        layout: Logging.layouts.pattern(
          pattern: options[:pattern],
          color_scheme: 'bright'
        )
      )
    )
  end

  def append_file
    create_directories
    logger.add_appenders(
      Logging.appenders.file(
        log_file,
        layout: Logging.layouts.pattern(pattern: options[:pattern])
      )
    )
  end

  def create_directories
    FileUtils.mkdir_p(LOG_PATH) unless File.directory?(LOG_PATH)
  end

  def log_file
    File.expand_path("#{name}.log", LOG_PATH)
  end

  def assign_log_level
    logger.level = options[:level] || :debug
  end
end
